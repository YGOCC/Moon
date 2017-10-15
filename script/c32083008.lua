--32083008
function c32083008.initial_effect(c)
	--spsum success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c32083008.gete)
	c:RegisterEffect(e1)
end
function c32083008.gete(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetPreviousLocation()~=LOCATION_REMOVED then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e:GetHandler():RegisterEffect(e1)
end
