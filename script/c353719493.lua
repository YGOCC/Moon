--Full Throttle Soul
function c353719493.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c353719493.con)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	c:RegisterEffect(e2)
	end
function c353719493.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c353719493.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c353719493.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x21ca)
end