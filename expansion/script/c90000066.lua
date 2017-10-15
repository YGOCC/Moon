--Royal Raid HP
function c90000066.initial_effect(c)
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--Activate Spell
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCountLimit(1)
	e1:SetTarget(c90000066.target)
	c:RegisterEffect(e1)
	--Activate Trap
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCountLimit(1)
	e2:SetTarget(c90000066.target)
	c:RegisterEffect(e2)
end
function c90000066.target(e,c)
	return c:IsSetCard(0x1c)
end