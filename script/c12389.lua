--Mecha Girl Transmutation
function c12389.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12389+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c12389.target)
	e1:SetOperation(c12389.operation)
	c:RegisterEffect(e1)
end
function c12389.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3052) and c:IsAbleToDeck() and c:IsFaceup()
end
function c12389.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_REMOVED) and chkc:IsControler(tp) and c12389.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c12389.filter,tp,LOCATION_MZONE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c12389.filter,tp,LOCATION_MZONE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c12389.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)~=0 then
		local ct=Duel.Draw(tp,1,REASON_EFFECT)
		if ct==0 then return end
		local dc=Duel.GetOperatedGroup():GetFirst()
		if dc:IsSetCard(0x3052) and Duel.IsPlayerCanDraw(tp,1)
			and Duel.SelectYesNo(tp,aux.Stringid(12389,0)) then
			Duel.BreakEffect()
			Duel.ConfirmCards(1-tp,dc)
			Duel.Draw(tp,1,REASON_EFFECT)
			Duel.ShuffleHand(tp)
		end
	end
end
