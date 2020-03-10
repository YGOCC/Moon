local cid,id=GetID()
--Roman Keys - XVIII
function cid.initial_effect(c)
	--This card's Level is doubled during the turn it is Summoned.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(cid.lvup)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--(Quick Effect): You can banish this card you control; Fusion Summon any number of "Roman Keys" or non-Effect Fusion monsters from your Extra Deck, using monsters from either field as material, but you cannot Summon monsters whose total Levels exceed the total Levels of the materials this way.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
end
function cid.lvup(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(e:GetHandler():GetLevel()*2)
	e:GetHandler():RegisterEffect(e1)
end
function cid.spfilter(c,e,tp,tg)
	return (c:IsSetCard(0x70b) or not c:IsType(TYPE_EFFECT)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,c:IsSetCard(0x70b),false) and Duel.GetLocationCountFromEx(tp,tp,tg)>0
end
function cid.filter(c,e,tp,mg)
	if c:IsFacedown() or not aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_FMATERIAL)
		or (fc and not c:IsCanBeFusionMaterial()) then return end
	local sg=Duel.GetMatchingGroup(cid.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if c:IsLocation(LOCATION_MZONE) then ft=ft+1 end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	return mg:CheckSubGroup(function(tg) return sg:CheckSubGroup(function(g) return g:GetSum(Card.GetLevel)<=tg:GetSum(Card.GetLevel) end,1,ft) end)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)+Duel.GetMatchingGroup(aux.AND(Card.IsFaceup,Card.IsCanBeFusionMaterial),tp,0,LOCATION_MZONE,nil)
		return mg:IsExists(cid.filter,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cid.mfilter(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local mg=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)+Duel.GetMatchingGroup(cid.mfilter,tp,0,LOCATION_MZONE,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local mat=mg:FilterSelect(tp,cid.filter,1,99,nil,e,tp,mg)
	if #mat==0 then return end
	local sg=Duel.GetMatchingGroup(cid.spfilter,tp,LOCATION_EXTRA,0,mat,e,tp,mat)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=sg:SelectSubGroup(tp,function(g) return g:GetSum(Card.GetLevel)<=mat:GetSum(Card.GetLevel) end,false,1,ft)
	for tc in aux.Next(tg) do tc:SetMaterial(mat) end
	Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.BreakEffect()
	local sc=tg:FilterSelect(tp,Card.IsSetCard,1,1,nil,0x70b):GetFirst()
	while sc do
		Duel.SpecialSummonStep(sc,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)
		sc:CompleteProcedure()
		sc=tg:Filter(Card.IsLocation,nil,LOCATION_EXTRA):FilterSelect(tp,Card.IsSetCard,1,1,nil,0x70b):GetFirst()
	end
	for nc in aux.Next(tg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)) do
		Duel.SpecialSummonStep(nc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		nc:CompleteProcedure()
	end
	Duel.SpecialSummonComplete()
end
