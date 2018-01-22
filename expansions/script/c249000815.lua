--Elemental Magic Burst
function c249000815.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c249000815.condition)
	e1:SetTarget(c249000815.target)
	e1:SetOperation(c249000815.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c249000815.thcon)
	e2:SetCost(c249000815.thcost)
	e2:SetTarget(c249000815.thtg)
	e2:SetOperation(c249000815.thop)
	c:RegisterEffect(e2)
end
function c249000815.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1F3)
end
function c249000815.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000815.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c249000815.filter(c)
	return c:IsFaceup()
end
function c249000815.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c249000815.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and c:IsFaceup() end
	if chk==0 then return Duel.IsExistingMatchingCard(c249000815.cfilter,tp,LOCATION_MZONE,0,1,nil,0x7F)
		and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=0
	if Duel.IsExistingMatchingCard(c249000815.cfilter,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_EARTH) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c249000815.cfilter,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_WATER) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c249000815.cfilter,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_FIRE) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c249000815.cfilter,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_WIND) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c249000815.cfilter,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_LIGHT) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c249000815.cfilter,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_DARK) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c249000815.cfilter,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_DEVINE) then ct=ct+1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c249000815.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c249000815.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c249000815.cfilter(c)
	return c:IsSetCard(0x1F3) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c249000815.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c249000815.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000815.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000815.thfilter(c)
	return c:IsSetCard(0x1F4) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c249000815.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000815.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c249000815.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c249000815.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
