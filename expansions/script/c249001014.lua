--Alchemy-Mage's Crest
function c249001014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c249001014.target)
	e1:SetOperation(c249001014.activate)
	c:RegisterEffect(e1)
end
function c249001014.filter(c)
	return c:IsSetCard(0x203) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c249001014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249001014.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c249001014.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c249001014.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if e:GetHandler():IsRelateToEffect(e) then
         e:GetHandler():CancelToGrave()
         Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_EFFECT)
    end
end
