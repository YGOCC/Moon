--created by Walrus, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e1:SetCondition(cid.con)
	e1:SetTarget(cid.tg)
	e1:SetOperation(cid.op)
	c:RegisterEffect(e1)
end
function cid.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and (c:IsPreviousLocation(LOCATION_EXTRA) or c:GetSummonLocation()==LOCATION_EXTRA)
end
function cid.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cid.cfilter,1,nil,1-tp) and not Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function cid.filter(c,e)
	return aux.disfilter1(c) and c:IsRelateToEffect(e)
end
function cid.rfilter(c)
	return c:IsSetCard(0xc97) and c:IsAbleToRemove()
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=eg:Filter(cid.cfilter,nil,1-tp)
	if chk==0 then return g:IsExists(aux.disfilter1,1,nil) and Duel.IsExistingMatchingCard(cid.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,nil) end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	local g=eg:Filter(cid.cfilter,nil,1-tp):Filter(cid.filter,nil,e)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		if tc:IsDisabled() then ct=ct+1 end
	end
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,cid.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,nil)
	if #rg>1 then
		Duel.BreakEffect()
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
