--Kaltes Mädchen das in den Wald ging
function c10100011.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100011,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,10100011)
	e1:SetTarget(c10100011.tg)
	e1:SetOperation(c10100011.op)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10100011,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,10100011)
	e2:SetCondition(c10100011.condition)
	e2:SetTarget(c10100011.tg)
	e2:SetOperation(c10100011.op)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100011,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c10100011.cost)
	e3:SetTarget(c10100011.target)
	e3:SetOperation(c10100011.operation)
	c:RegisterEffect(e3)
end
function c10100011.filter1(c)
	return c:IsSetCard(0x321) and c:IsType(TYPE_MONSTER) and not c:IsCode(10100011) and c:IsAbleToHand()
end
function c10100011.filter2(c)
	return c:IsSetCard(0x321) and c:IsType(TYPE_MONSTER) and not c:IsCode(10100011) and c:IsAbleToDeck()
end
function c10100011.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c10100011.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100011.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10100011.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10100011.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10100011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100011.filter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_GRAVE)
	local g=Duel.DiscardHand(tp,c10100011.filter2,1,1,REASON_COST+REASON_DISCARD)
end
function c10100011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	
end
function c10100011.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end