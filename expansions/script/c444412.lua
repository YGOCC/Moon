-- Modular Barrier Type S
function c444412.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c444412.efilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e2)
end
function c444412.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)and te:GetOwner()~=e:GetOwner()
end