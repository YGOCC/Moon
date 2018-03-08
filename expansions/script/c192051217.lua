--coded by Lyris
--Steelus Eternitem
function c192051217.initial_effect(c)
	c:EnableReviveLimit()
	--2 Level 3 "Steelus" monsters
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x617),3,2)
	--Once per turn: You can detach 1 material from this card; add 1 "Steelus" card from your Deck to your hand.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(192051217,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c192051217.cost)
	e1:SetTarget(c192051217.target)
	e1:SetOperation(c192051217.operation)
	c:RegisterEffect(e1)
end
function c192051217.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c192051217.filter(c)
	return c:IsSetCard(0x617) and c:IsAbleToHand()
end
function c192051217.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c192051217.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c192051217.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c192051217.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
