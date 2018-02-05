--Abscheuliche Wollust
function c10100107.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100107,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,10100107+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(c10100107.cost)
	e1:SetTarget(c10100107.target)
	e1:SetOperation(c10100107.operation)
	c:RegisterEffect(e1)
end
function c10100107.cfilter(c)
	return c:IsSetCard(0x328) and not c:IsPublic()
end
function c10100107.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100107.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c10100107.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c10100107.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c10100107.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(1-tp,1,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(tp,tc)
	if tc:IsType(TYPE_SPELL) or tc:IsType(TYPE_MONSTER) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	    local dg=Duel.SelectTarget(1-tp,c10100107.filtermm2,1-tp,0,LOCATION_DECK,2,2,nil)
		Duel.SendtoHand(dg,1-tp,2,REASON_EFFECT)
		Duel.ConfirmCards(tp,dg)
	end	
	Duel.ShuffleHand(1-tp)
end
function c10100107.filtermm2(c)
	return c:IsSetCard(0x328) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() 
end