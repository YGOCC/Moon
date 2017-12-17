--Kalte Stille die komplett gefroren war
function c10100075.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10100075.condition)
	e1:SetTarget(c10100075.target)
	e1:SetOperation(c10100075.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c10100075.spcost)
	e2:SetTarget(c10100075.target1)
	e2:SetOperation(c10100075.activate1)
	c:RegisterEffect(e2)
end
function c10100075.cfilter(c,tp)
	return c:GetSummonPlayer()==1-tp
end
function c10100075.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10100075.cfilter,1,nil,tp)
end
function c10100075.filter(c)
	return c:IsSetCard(0x321) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10100075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100075.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10100075.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10100075.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10100075.dfilter(c)
	return c:IsSetCard(0x321) and c:IsAbleToDeckAsCost()
end
function c10100075.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100075.dfilter,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10100075.dfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,0,REASON_COST)
	Duel.ShuffleDeck(tp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c10100075.filter1(c)
	return c:IsSetCard(0x321) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10100075.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100075.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10100075.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10100075.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end