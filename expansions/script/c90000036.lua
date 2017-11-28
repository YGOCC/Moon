--Toxic Tuner Token
function c90000036.initial_effect(c)
	--Synchro Limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetValue(c90000036.value1)
	c:RegisterEffect(e1)
end
function c90000036.value1(e,c)
	if not c then return false end
	return not c:IsSetCard(0x14)
end