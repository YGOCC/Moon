--Digimon Xros United Army
function c47000119.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c47000119.condition)
	e1:SetCountLimit(1,47000119)
	e1:SetTarget(c47000119.target)
	e1:SetOperation(c47000119.activate)
	c:RegisterEffect(e1)
--shuffle into deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c47000119.tdtg)
	e2:SetOperation(c47000119.tdop)
	c:RegisterEffect(e2)
end
function c47000119.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2EEF) 
end
function c47000119.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c47000119.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c47000119.filter(c)
	return c:IsSetCard(0x2EEF) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c47000119.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47000119.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47000119.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c47000119.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c47000119.tdfilter(c)
	return c:IsSetCard(0x2EEF) and c:IsAbleToDeck()
end
function c47000119.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingMatchingCard(c47000119.tdfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c47000119.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.SelectMatchingCard(tp,c47000119.tdfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
	local g2=Group.FromCards(c)
	g1:Merge(g2)
	if g1:GetCount()==3 then
		Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
	end
end

