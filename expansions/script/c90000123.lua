--Unreal Sound Manager
function c90000123.initial_effect(c)
	--Gemini Summon
	aux.EnableDualAttribute(c)
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--Scale Change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(2)
	e1:SetCondition(c90000123.condition)
	e1:SetCost(c90000123.cost)
	e1:SetOperation(c90000123.operation)
	c:RegisterEffect(e1)
	--ATK/DEF Up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(aux.IsDualState)
	e2:SetCondition(c90000123.condition2)
	e2:SetTarget(c90000123.target)
	e2:SetOperation(c90000123.operation2)
	c:RegisterEffect(e2)
end
function c90000123.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_DUAL)
end
function c90000123.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c90000123.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c90000123.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c90000123.operation(e,tp,eg,ep,ev,re,r,rp)
	local val=Duel.GetMatchingGroup(c90000123.filter,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetLevel)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	e:GetHandler():RegisterEffect(e2)
end
function c90000123.filter2(c)
	return c:IsFaceup() and c:IsDualState()
end
function c90000123.condition2(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c90000123.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90000123.filter2,tp,LOCATION_MZONE,0,1,nil) end
end
function c90000123.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c90000123.filter2,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(700)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end