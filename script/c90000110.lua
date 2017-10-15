--Spectral Interfere
function c90000110.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--ATK Up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,90000110)
	e2:SetCondition(c90000110.condition)
	e2:SetOperation(c90000110.operation)
	c:RegisterEffect(e2)
end
function c90000110.filter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c90000110.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if a:IsControler(1-tp) then a,bc=bc,a end
	return a:IsSetCard(0x5d) and a:IsRelateToBattle()
		and Duel.IsExistingMatchingCard(c90000110.filter,tp,LOCATION_MZONE,0,1,a,a:GetCode())
end
function c90000110.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local a=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,bc=bc,a end
	if a:IsRelateToBattle() and a:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(a:GetAttack()*2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		a:RegisterEffect(e1)
	end
end