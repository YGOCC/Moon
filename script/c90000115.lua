--Spectral Mirage
function c90000115.initial_effect(c)
	--Change Name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c90000115.target)
	e1:SetOperation(c90000115.operation)
	c:RegisterEffect(e1)
end
function c90000115.filter(c,tp)
	return Duel.IsExistingMatchingCard(c90000115.filter2,tp,LOCATION_GRAVE,0,2,c,c:GetCode())
end
function c90000115.filter2(c,code)
	return c:IsCode(code)
end
function c90000115.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90000115.filter,tp,LOCATION_GRAVE,0,3,nil,tp)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
function c90000115.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(90000101)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end