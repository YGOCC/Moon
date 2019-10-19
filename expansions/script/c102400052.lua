local cid,id=GetID()
--Destrick Repairing
function cid.initial_effect(c)
	--Target 3 of your banished cards and 2 "Destrick" monsters with different names in your GY; shuffle them into the Deck, then draw 2 cards. You can only activate 1 "Destrick Repairing" per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetTarget(cid.drawtarget)
	e1:SetOperation(cid.drawop)
	c:RegisterEffect(e1)
end
function cid.todeckfilter(c,e)
	return c:IsSetCard(0x5cd) and c:IsAbleToDeck() and not c:IsCode(id) and c:IsCanBeEffectTarget(e)
end
function cid.drawtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(cid.todeckfilter,tp,LOCATION_GRAVE,0,1,nil,e)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and g:GetClassCount(Card.GetCode)>1
		and Duel.IsExistingTarget(nil,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
	Duel.SetTargetCard(sg+g:Select(tp,1,1,nil)+Duel.SelectMatchingCard(tp,Card.IsCanBeEffectTarget,tp,LOCATION_REMOVED,0,3,3,nil,e))
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cid.drawop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)==0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>=1 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
