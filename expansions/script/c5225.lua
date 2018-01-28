--Lesser Maw, Quiksan
function c5225.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5225,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,5225)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c5225.cost)
	e1:SetTarget(c5225.target)
	e1:SetOperation(c5225.operation)
	c:RegisterEffect(e1)
end
function c5225.cfilter(c,tp)
	return c:IsSetCard(0x104a) and c:IsType(TYPE_MONSTER) and not c:IsCode(5225) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c5225.filter,tp,LOCATION_DECK,0,1,c)
end
function c5225.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5225.cfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c5225.cfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c5225.filter(c)
	return c:IsSetCard(0x104a) and not c:IsCode(5225) and c:IsAbleToHand()
end
function c5225.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c5225.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c5225.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end