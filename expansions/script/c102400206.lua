--created & coded by Lyris
--ローマ・キ ー・XVIII
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
end
function cid.spfilter(c,e,tp)
	return (c:IsSetCard(0xeeb) or not c:IsType(TYPE_EFFECT)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,c:IsSetCard(0xeeb),false)
end
function cid.filter(c,e,tp,ft,mg)
	if (c:IsOnField() and c:IsFacedown()) or not aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_FMATERIAL)
		or (c:IsControler(1-tp) and not c:IsSetCard(0xeeb)) then return false end
	local sg=Duel.GetMatchingGroup(cid.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if not ft then ft=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION) end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	return #sg>0 and (not mg or mg:CheckSubGroup(function(tg) return sg:CheckSubGroup(function(g) return g:GetSum(Card.GetLevel)<=tg:GetSum(Card.GetLevel) end) end))
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,e:GetHandler())+Duel.GetMatchingGroup(aux.AND(Card.IsFaceup,Card.IsCanBeFusionMaterial),tp,0,LOCATION_MZONE,nil)
		aux.GCheckAdditional=function(lg) return lg:FilterCount(Card.IsControler,nil,1-tp)<=1 end
		local mat=mg:CheckSubGroup(cid.gcheck,1,99,e,tp)
		aux.GCheckAdditional=nil
		return mat
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cid.mfilter(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function cid.gcheck(g,e,tp,mg)
	if #g==0 then return true end
	return g:IsExists(cid.filter,#g,nil,e,tp,Duel.GetLocationCountFromEx(tp,tp,g,TYPE_FUSION),mg)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)+Duel.GetMatchingGroup(cid.mfilter,tp,0,LOCATION_MZONE,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	aux.GCheckAdditional=function(lg) return lg:FilterCount(Card.IsControler,nil,1-tp)<=1 end
	local mat=mg:SelectSubGroup(tp,cid.gcheck,false,1,99,e,tp)
	aux.GCheckAdditional=nil
	if not mat or #mat==0 then return end
	local sg=Duel.GetMatchingGroup(cid.spfilter,tp,LOCATION_EXTRA,0,mat,e,tp)
	local ft=Duel.GetLocationCountFromEx(tp,tp,mat,TYPE_FUSION)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=sg:SelectSubGroup(tp,function(g) return g:GetSum(Card.GetLevel)<=mat:GetSum(Card.GetLevel) end,false,1,ft)
	for tc in aux.Next(tg) do tc:SetMaterial(mat) end
	Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.BreakEffect()
	for nc in aux.Next(tg) do
		Duel.SpecialSummonStep(nc,SUMMON_TYPE_FUSION,tp,tp,nc:IsSetCard(0xeeb),false,POS_FACEUP)
		nc:CompleteProcedure()
	end
	Duel.SpecialSummonComplete()
end
