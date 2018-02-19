function c90210016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,90210016+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c90210016.cost)
	e1:SetTarget(c90210016.target)
	e1:SetOperation(c90210016.activate)
	c:RegisterEffect(e1)
end
function c90210016.filter2(c)
	return c:IsSetCard(0x12D) and c:IsType(TYPE_MONSTER)
end
function c90210016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90210016.filter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c90210016.filter2,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c90210016.filter(c)
	return (c:IsSetCard(0x12C) or c:IsSetCard(0x12F) or c:IsSetCard(0x130)) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c90210016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90210016.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c90210016.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c90210016.filter,tp,LOCATION_DECK,0,1,1,nil,TYPE_SPELL)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end