--FFX - Frag Grenade
function c20386027.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c20386027.condition)
	e1:SetTarget(c20386027.target)
	e1:SetOperation(c20386027.activate)
	c:RegisterEffect(e1)
end
function c20386027.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x31C55) or c:IsCode(20386000)
end
function c20386027.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c20386027.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c20386027.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c20386027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20386027.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function c20386027.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c20386027.filter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end