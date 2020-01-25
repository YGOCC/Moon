--created by Walrus, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e1:SetCondition(cid.con)
	e1:SetTarget(cid.tg)
	e1:SetOperation(cid.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE) 
	e2:SetCountLimit(1,id+100)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetTarget(cid.rmtg)
	e2:SetOperation(cid.rmop)
	c:RegisterEffect(e2)
end
function cid.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and (c:IsPreviousLocation(LOCATION_EXTRA) or c:GetSummonLocation()==LOCATION_EXTRA)
end
function cid.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cid.cfilter,1,nil,1-tp) and not Duel.IsExistingMatchingCard(aux.AND(cid.cfilter,aux.FilterBoolFunction(Card.IsSetCard,0xc97)),tp,LOCATION_MZONE,0,1,nil,tp)
		and #(Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)-e:GetHandler())>0 and not Duel.IsExistingMatchingCard(aux.OR(Card.IsFacedown,Card.IsSetCard),tp,LOCATION_ONFIELD,0,1,c,0xc97)
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
	if #(Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)-c)==0 or not Duel.IsExistingMatchingCard(aux.OR(Card.IsFacedown,Card.IsSetCard),tp,LOCATION_ONFIELD,0,1,c,0xc97) then return end
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
function cid.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function cid.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,2,nil)
	if #g>0 then Duel.Remove(g,POS_FACEUP,REASON_EFFECT) end
end
