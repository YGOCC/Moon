local cid,id=GetID()
--Roman Keys - XXXVI
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
end
function cid.spfilter(c,e,tp,tg)
	return (c:IsSetCard(0xeeb) or not c:IsType(TYPE_EFFECT)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,c:IsSetCard(0xeeb),false) and Duel.GetLocationCountFromEx(tp,tp,tg)>0
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
function cid.mfilter(c)
	return c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(cid.mfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,e:GetHandler())
		return mg:IsExists(cid.filter,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local mg=Duel.GetMatchingGroup(cid.mfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local mat=mg:FilterSelect(tp,cid.filter,1,99,nil,e,tp,mg)
	if #mat==0 then return end
	local sg=Duel.GetMatchingGroup(cid.spfilter,tp,LOCATION_EXTRA,0,mat,e,tp,mat)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=sg:SelectSubGroup(tp,function(g) return g:GetSum(Card.GetLevel)<=mat:GetSum(Card.GetLevel) end,false,1,ft)
	for tc in aux.Next(tg) do tc:SetMaterial(mat) end
	Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.BreakEffect()
	local sc=tg:FilterSelect(tp,Card.IsSetCard,1,1,nil,0xeeb):GetFirst()
	while sc do
		Duel.SpecialSummonStep(sc,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)
		sc:CompleteProcedure()
		sc=tg:Filter(Card.IsLocation,nil,LOCATION_EXTRA):FilterSelect(tp,Card.IsSetCard,1,1,nil,0xeeb):GetFirst()
	end
	for nc in aux.Next(tg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)) do
		Duel.SpecialSummonStep(nc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		nc:CompleteProcedure()
	end
	Duel.SpecialSummonComplete()
end
