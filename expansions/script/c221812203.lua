--Viravolve Elk Cloner
function c221812203.initial_effect(c)
	--When your opponent takes damage: You can reveal this card in your hand; reveal 3 "Viravolve" cards from your Deck with different names, your opponent picks 1 of them for you to add to your hand, also shuffle the other cards into the Deck. You can only use this effect of "Viravolve Elk Cloner" once per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,221812203)
	e1:SetCondition(c221812203.condition)
	e1:SetCost(c221812203.cost)
	e1:SetTarget(c221812203.target)
	e1:SetOperation(c221812203.operation)
	c:RegisterEffect(e1)
	--If this card is sent from the field to the GY, or detached from an Xyz Monster, inflict 200 damage to your opponent.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c221812203.thcon)
	e2:SetOperation(c221812203.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(function(e) local c=e:GetHandler() return c:IsPreviousLocation(LOCATION_OVERLAY) and not c:IsReason(REASON_LOST_TARGET) end)
	c:RegisterEffect(e3)
end
function c221812203.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c221812203.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c221812203.filter(c)
	return c:IsSetCard(0xa67) and c:IsAbleToHand()
end
function c221812203.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c221812203.filter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c221812203.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c221812203.filter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg3=g:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		sg1:Merge(sg3)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=sg1:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c221812203.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=c:GetPreviousLocation()
	return (bit.band and bit.band(loc,LOCATION_ONFIELD)~=0) or loc&LOCATION_ONFIELD~=0 or (loc==LOCATION_OVERLAY and not c:IsReason(REASON_RULE))
end
function c221812203.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,221812203)
	Duel.Damage(1-tp,200,REASON_EFFECT)
end
