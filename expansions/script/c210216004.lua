function c210216004.initial_effect(c)
	--Activate Search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,210216004)
	e1:SetTarget(c210216004.target)
	e1:SetOperation(c210216004.activate)
	c:RegisterEffect(e1)
  --activate trap in hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
    e2:SetTarget(c210216004.etarget)
    c:RegisterEffect(e2)
	--cannot be tributed
	local e4y=Effect.CreateEffect(c)
	e4y:SetType(EFFECT_TYPE_FIELD)
	e4y:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4y:SetRange(LOCATION_FZONE)
	e4y:SetTargetRange(LOCATION_MZONE,0)
	e4y:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x216))
	e4y:SetValue(1)
	c:RegisterEffect(e4y)
	local e4yx=e4y:Clone()
	e4yx:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e4yx)
end
function c210216004.etarget(e,c)
	return c:GetType()==TYPE_TRAP and c:IsSetCard(0x216)
end
function c210216004.searchfilter(c)
	return c:IsSetCard(0x216) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c210216004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210216004.searchfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c210216004.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c210216004.searchfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
end