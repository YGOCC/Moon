--Number Armor Void
function c249000871.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c249000871.condition)
	e1:SetTarget(c249000871.target)
	e1:SetOperation(c249000871.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c249000871.handcon)
	c:RegisterEffect(e2)
end
function c249000871.cfilter(c)
	return c:IsSetCard(0x48) and c:IsFaceup()
end
function c249000871.condition(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not Duel.IsExistingMatchingCard(c249000871.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return Duel.IsChainNegatable(ev)
end
function c249000871.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c249000871.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if eg:GetFirst():IsAbleToRemove() then
			Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		else
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end
function c249000871.handfilter(c)
	return c:IsCode(249000868,249000869) and c:IsFaceup()
end
function c249000871.handcon(e)
	return Duel.IsExistingMatchingCard(c249000871.handfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,1,nil)
end