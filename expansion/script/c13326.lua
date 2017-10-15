--
function c13326.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c13326.target)
	e1:SetOperation(c13326.activate)
	c:RegisterEffect(e1)
	--Atk 0
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13326,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c13326.condition2)
	e2:SetCost(c13326.cost)
	e2:SetTarget(c13326.target2)
	e2:SetOperation(c13326.operation2)
	c:RegisterEffect(e2)
end
function c13326.filter(c)
	return c:IsSetCard(0x5DD) and c:IsFaceup() and c:GetAttack()>0
end
function c13326.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13326.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c13326.dfilter(c)
	return c:IsSetCard(0x5DD) and c:IsFaceup() and c:GetAttack()==0
end
function c13326.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c13326.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
		if Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c13326.dfilter,tp,LOCATION_MZONE,0,2,nil) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c13326.condition2(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e)
end
function c13326.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c13326.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13326.filter2,tp,LOCATION_MZONE,0,1,nil) end
end
function c13326.filter2(c)
	return c:IsSetCard(0x5DD) and c:IsFaceup() and c:GetAttack()~=c:GetBaseAttack()
end
function c13326.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c13326.filter2,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetBaseAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
