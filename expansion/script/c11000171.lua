--PROJECT Recall
function c11000171.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11000171,0))
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,11000171)
	e2:SetCost(c11000171.cost)
	e2:SetTarget(c11000171.target)
	e2:SetOperation(c11000171.operation)
	c:RegisterEffect(e2)
end
function c11000171.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1F7) and c:IsAbleToHandAsCost()
end
function c11000171.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if ft<0 then return false end
		if ft==0 then
			return Duel.IsExistingMatchingCard(c11000171.filter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		else
			return Duel.IsExistingMatchingCard(c11000171.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	if ft==0 then
		local g=Duel.SelectMatchingCard(tp,c11000171.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
		Duel.SendtoHand(g,nil,REASON_COST)
	else
		local g=Duel.SelectMatchingCard(tp,c11000171.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
		Duel.SendtoHand(g,nil,REASON_COST)
	end
end
function c11000171.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c11000171.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end