--FFX-Celestial Weapons
function c20386023.initial_effect(c)
	c:SetUniqueOnField(1,0,20386023)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x31C55))
	c:RegisterEffect(e2)
		--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PIERCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,20386000))
	c:RegisterEffect(e3)
		--counter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c20386023.condition)
	e4:SetOperation(c20386023.ctop)
	c:RegisterEffect(e4)
	--atk up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_DAMAGE_CALCULATING)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(c20386023.atkup)
	c:RegisterEffect(e5)
end
function c20386023.atkup(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsSetCard(0x31C55) or a:IsCode(20386000) or not d or a:GetAttack()>=d:GetAttack() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_PHASE+RESET_DAMAGE_CAL)
	e1:SetValue(500)
	a:RegisterEffect(e1)
end
function c20386023.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(tp) and Duel.GetAttacker():IsSetCard(0x31C55) or Duel.GetAttacker():IsCode(20386000)
end
function c20386023.ctop(e,tp,eg,ep,ev,re,r,rp)
		Duel.GetAttacker():AddCounter(0x94b,2)
end