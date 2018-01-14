--Chaos-Mage's Dimensional Charm
function c249000795.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c249000795.condition)
	e1:SetTarget(c249000795.target)
	e1:SetOperation(c249000795.activate)
	c:RegisterEffect(e1)
end
function c249000795.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x30CF) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000795.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000795.cfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c249000795.filter(c,e)
	return c:IsAbleToDeck() and c:IsCanBeEffectTarget(e) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000795.filter2(c,e)
	return c:IsAbleToDeck() and c:IsCanBeEffectTarget(e) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000795.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		if not Duel.IsPlayerCanDraw(tp,2) then return false end
		if not Duel.IsExistingMatchingCard(c249000795.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e) then return end
		local g=Duel.GetMatchingGroup(c249000795.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
		return g:GetClassCount(Card.GetRace)>=2
	end
	local g=Duel.GetMatchingGroup(c249000795.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsRace,nil,g1:GetFirst():GetRace())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=g:Select(tp,1,1,nil)
	g:Remove(Card.IsRace,nil,g2:GetFirst():GetRace())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g3=Duel.SelectMatchingCard(tp,c249000795.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c249000795.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
