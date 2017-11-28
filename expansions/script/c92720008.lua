--Chronowitch Stars
function c92720008.initial_effect(c)
	c:EnableCounterPermit(0x2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,92720008)
	e1:SetTarget(c92720008.cttg)
	e1:SetOperation(c92720008.ctop)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c92720008.tg)
	e2:SetValue(c92720008.value)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(92720008,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c92720008.thcost)
	e3:SetTarget(c92720008.thtg)
	e3:SetOperation(c92720008.thop)
	c:RegisterEffect(e3)
end
function c92720008.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c92720008.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x2,1)
		tc=g:GetNext()
	end
end
function c92720008.tg(e,c)
	return c:IsSetCard(0xf92) and c:IsType(TYPE_MONSTER) and c:GetCounter(0x2)==0 and c:GetOriginalLevel()>0
end
function c92720008.value(e,c)
	local p=e:GetHandler():GetControler()
		return c:GetBaseAttack()*2
end
function c92720008.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x2,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x2,1,REASON_COST)
end
function c92720008.thfilter(c)
	return c:IsSetCard(0xf92) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c92720008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c92720008.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c92720008.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c92720008.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
