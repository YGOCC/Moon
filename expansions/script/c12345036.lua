--gate
function c12345036.initial_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12345036,0))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetHintTiming(0,0x16F)
	e3:SetOperation(c12345036.operation)
	e3:SetTarget(c12345036.target)
	e3:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e3)
	
end
function c12345036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12345036.filt,tp,LOCATION_MZONE,0,1,nil) end
end
function c12345036.filt(c)
	return c:IsFaceup() and c:IsSetCard(0x16F)
end



function c12345036.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c12345036.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c12345036.filt,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetOperation(c12345036.operation)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e3:SetValue(c12345036.efilter)
	tc:RegisterEffect(e3)
	tc=g:GetNext()
	end
end