--Empire Sword Breaker
function c90000086.initial_effect(c)
	c:EnableReviveLimit()
	--Ritual Level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_RITUAL_LEVEL)
	e1:SetValue(c90000086.value1)
	c:RegisterEffect(e1)
	--Add Counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_RELEASE)
	e2:SetTarget(c90000086.target2)
	e2:SetOperation(c90000086.operation2)
	c:RegisterEffect(e2)
end
function c90000086.value1(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x5d) then
		return lv*65536+c:GetLevel()
	else
		return lv
	end
end
function c90000086.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,0,LOCATION_ONFIELD,1,nil,0x1000,1) end
end
function c90000086.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,0,LOCATION_ONFIELD,nil,0x1000,1)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1000,1)
		tc=g:GetNext()
	end
end