--Chaos Wand
function c90000065.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Battle Indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c90000065.condition1)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2d))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Effect Indestructable
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
end
function c90000065.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x2d)
end
function c90000065.condition1(e)
	return Duel.IsExistingMatchingCard(c90000065.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil)
end