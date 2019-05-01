--Discovering the Possibilities
function c249000248.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,249000248+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c249000248.cost)
	e1:SetTarget(c249000248.target)
	e1:SetOperation(c249000248.activate)
	c:RegisterEffect(e1)
end
function c249000248.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST+REASON_DISCARD)
end
function c249000248.filter(c,code)
	return c:IsSetCard(0x159) and c:IsAbleToHand() and c:GetCode()~=code
end
function c249000248.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000248.filter,tp,LOCATION_DECK,0,1,nil,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c249000248.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c249000248.filter,tp,LOCATION_DECK,0,1,1,nil,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local g2=Duel.GetMatchingGroup(c249000248.filter,tp,LOCATION_DECK,0,nil,g:GetFirst():GetCode())
	if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(249000248,0)) then
		local g3=g2:Select(tp,1,1,nil)
		Duel.SendtoHand(g3,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g3)
	end
end
