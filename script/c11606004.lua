--Shark Boss
function c11606004.initial_effect(c)
	--base attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c11606004.atkval)
	c:RegisterEffect(e1)
end
function c11606004.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FISH)and c:IsSetCard(0x2D56)
end
function c11606004.atkval(e,c)
	return Duel.GetMatchingGroupCount(c11606004.filter,c:GetControler(),LOCATION_GRAVE,0,nil)*1000
end