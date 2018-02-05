--Abscheuliche Wollust
function c10100108.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10100108+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10100108.cost)
	e1:SetTarget(c10100108.target)
	e1:SetOperation(c10100108.activate)
	c:RegisterEffect(e1)
end
function c10100108.cfilter(c)
	return c:IsSetCard(0x328) and not c:IsPublic()
end
function c10100108.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100108.cfilter,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c10100108.cfilter,tp,LOCATION_HAND,0,2,2,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c10100108.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>9 end
end
function c10100108.filter(c)
	return c:IsAbleToHand()
end
function c10100108.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)<10 then return end
	local g=Duel.GetDecktopGroup(1-tp,10)
	Duel.ConfirmCards(tp,g)
	if g:IsExists(c10100108.filter,2,nil) and Duel.SelectYesNo(tp,aux.Stringid(10100108,0)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c10100108.filter,2,2,nil)
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		Duel.ShuffleDeck(1-tp)
	end
end