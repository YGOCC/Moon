--Ahri's Spirit Rush
function c11000560.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c11000560.condition)
	e1:SetTarget(c11000560.target)
	e1:SetOperation(c11000560.activate)
	c:RegisterEffect(e1)
end
function c11000560.cfilter(c)
	return c:IsFaceup() and c:IsCode(11000550)
end
function c11000560.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
		and Duel.IsExistingMatchingCard(c11000560.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c11000560.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and c:IsDestructable()
end
function c11000560.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c11000560.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11000560.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c11000560.filter,tp,0,LOCATION_ONFIELD,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c11000560.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.Destroy(sg,REASON_EFFECT)
		local lp=Duel.GetLP(tp)
	if lp<=ct*1000 then
		Duel.SetLP(tp,0)
	else
		Duel.SetLP(tp,lp-ct*1000)
	end
end