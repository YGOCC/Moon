--created by Meedogh, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrigBigbangType(c)
	aux.AddBigbangProc(c,aux.FilterBoolFunction(Card.IsCode,81455788),1,aux.NOT(aux.FilterEqualFunction(Card.GetVibe,0)),1)
	aux.AddCodeList(c,81455788)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(2)
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.sptg)
	e1:SetOperation(cid.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(1124)
	e2:SetTarget(cid.tg)
	e2:SetOperation(cid.op)
	c:RegisterEffect(e2)
end
function cid.cfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcf11) and c:IsDiscardable()
		and Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function cid.filter(c,e,tp,code)
	return c:IsSetCard(0xcf11) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(code)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,cid.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel())
	if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
end
function cid.desfilter(c,tp)
	local ec=c:GetEquipTarget()
	return ec and ec:IsType(TYPE_BIGBANG) and c:IsDestructable() and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,1,c)
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	Duel.Destroy(Duel.SelectMatchingCard(tp,cid.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,tp),REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD+LOCATION_HAND)
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,1,1,nil)
	if #tg>0 then
		Duel.HintSelection(tg)
		Duel.BreakEffect()
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
