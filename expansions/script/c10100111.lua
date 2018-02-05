--Abscheulicher Zorn
function c10100111.initial_effect(c)
    --effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100111,0))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,10100111+EFFECT_COUNT_CODE_OATH)
	e3:SetCost(c10100111.cost)
	e3:SetTarget(c10100111.drtg2)
	e3:SetOperation(c10100111.drop2)
	c:RegisterEffect(e3)
end
function c10100111.cfilter(c)
	return c:IsSetCard(0x328) and not c:IsPublic()
end
function c10100111.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100111.cfilter,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c10100111.cfilter,tp,LOCATION_HAND,0,2,2,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c10100111.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_DECK) and c10100111.filtermm2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10100111.filtermm2,1-tp,0,LOCATION_DECK,1,nil) end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(1-tp,c10100111.filtermm2,1-tp,0,LOCATION_DECK,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10100111.filtermm2(c)
	return c:IsSetCard(0x328) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() 
end
function c10100111.drop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,tc)
	end
end