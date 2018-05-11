--Number U301: Neon Galaxy-Eyes Photonic Creation Dragon
function c88880056.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c88880056.splimit)
	c:RegisterEffect(e1)
end
--(1) spsummon limit
function c88880056.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(88880045) and se:GetHandler():IsType(TYPE_SPELL)
end