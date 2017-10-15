--Empire Intercept Order
function c90000078.initial_effect(c)
	--Add Counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c90000078.target)
	e1:SetOperation(c90000078.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c90000078.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToGrave()
end
function c90000078.filter1(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()~=tp
end
function c90000078.filter2(c,e,tp)
	return c:IsFaceup() and c:GetSummonPlayer()~=tp and c:IsRelateToEffect(e) 
end
function c90000078.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90000078.filter,tp,LOCATION_DECK,0,1,nil)
		and eg:IsExists(c90000078.filter1,1,nil,tp) end
	Duel.SetTargetCard(eg)
end
function c90000078.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c90000078.filter2,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1000,1)
		tc=g:GetNext()
	end
	local gs=Duel.GetMatchingGroup(c90000078.filter,tp,LOCATION_DECK,0,nil):RandomSelect(tp,1)
	Duel.SendtoGrave(gs,REASON_EFFECT)
end