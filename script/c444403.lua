-- Modular Barrier Type M
function c444403.initial_effect(c)
	-- immunity
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
	e1:SetCondition(c444403.passivescondition)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c444403.efilter)
	c:RegisterEffect(e1)
end
function c444403.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER)and te:GetOwner()~=e:GetOwner()
end
function c444403.passivescondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqc=c:GetEquipTarget()
	return  not eqc 
end