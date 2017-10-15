--Influx of Venom
function c90000038.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--ATK Up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c90000038.value)
	c:RegisterEffect(e2)
	--DEF Up
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--ATK Down
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(c90000038.value2)
	c:RegisterEffect(e4)
	--DEF Down
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
	--Negate Effect
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c90000038.condition)
	e6:SetTarget(c90000038.target)
	e6:SetOperation(c90000038.operation)
	c:RegisterEffect(e6)
	--ATK/DEF 0
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetCondition(c90000038.condition2)
	e7:SetTarget(c90000038.target2)
	e7:SetOperation(c90000038.operation2)
	c:RegisterEffect(e7)
end
function c90000038.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x14)
end
function c90000038.value(e,c)
	return Duel.GetMatchingGroupCount(c90000038.filter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)*200
end
function c90000038.value2(e,c)
	return Duel.GetMatchingGroupCount(c90000038.filter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)*-200
end
function c90000038.filter2(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x14)
end
function c90000038.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c90000038.filter2,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c90000038.filter3(c)
	return c:IsFaceup() and c:IsSetCard(0x14) and c:IsAbleToHand()
end
function c90000038.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c90000038.filter3,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c90000038.filter3,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c90000038.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		Duel.NegateActivation(ev)
	end
end
function c90000038.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and rp~=tp and c:IsStatus(STATUS_ACTIVATED)
end
function c90000038.filter4(c)
	return c:IsFaceup() and not c:IsSetCard(0x14)
end
function c90000038.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90000038.filter4,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c90000038.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c90000038.filter4,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000) 
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end