--Reconnaissance
function c21495511.initial_effect(c)
	--confirm
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21495511+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c21495511.cost)
	e1:SetTarget(c21495511.target)
	e1:SetOperation(c21495511.operation)
	c:RegisterEffect(e1)
end

function c21495511.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c21495511.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c21495511.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x150)
end

function c21495511.filter(c)
	return (c:IsOnField() and c:IsFacedown()) or (c:IsLocation(LOCATION_HAND) and not c:IsPublic())
end
function c21495511.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21495511.filter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil) end	
end

function c21495511.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21495511.filter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
	Duel.ConfirmCards(tp,g)
	Duel.ShuffleHand(1-tp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
