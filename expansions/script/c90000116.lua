--Unreal Jumper Dolphin
function c90000116.initial_effect(c)
	--Gemini Summon
	aux.EnableDualAttribute(c)
	--Tribute X2
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e1:SetCondition(aux.IsDualState)
	e1:SetValue(c90000116.value)
	c:RegisterEffect(e1)
end
function c90000116.value(e,c)
	return c:IsType(TYPE_DUAL)
end