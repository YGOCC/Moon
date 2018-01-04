--Osa, Princess of Stellar VINE
c240100431.spt_another_space=240100434
function c240100431.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrigSpatialType(c)
	--Materials: 1 WATER monster + 1 WATER monster with less DEF (max. 400)
	aux.AddSpatialProc(c,nil,4,nil,400,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	--Once per turn: You can shuffle 1 of your banished monsters into the Deck, then target up to 3 of your banished "Stellar VINE" monsters; return all of those targets to the GY, then draw 1 card.
	local ae1=Effect.CreateEffect(c)
	ae1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	ae1:SetType(EFFECT_TYPE_IGNITION)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae1:SetCountLimit(1)
	ae1:SetCost(c240100431.cost)
	ae1:SetTarget(c240100431.target)
	ae1:SetOperation(c240100431.op)
	c:RegisterEffect(ae1)
end
function c240100431.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost() and Duel.IsExistingTarget(c240100431.filter,tp,LOCATION_REMOVED,0,3,c)
end
function c240100431.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x285b) and c:IsAbleToGrave()
end
function c240100431.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c240100431.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c240100431.filter(chkc) end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c240100431.cfilter,tp,LOCATION_REMOVED,0,1,nil,tp) and Duel.IsPlayerCanDraw(tp,1)
	end
	local g=Duel.SelectMatchingCard(tp,c240100431.cfilter,tp,LOCATION_REMOVED,0,1,1,nil,tp)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	Duel.ShuffleDeck(tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(240100238,0))
	local g=Duel.SelectTarget(tp,c240100431.filter,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c240100431.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoGrave(tg,REASON_EFFECT+REASON_RETURN)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
	if ct==g:GetCount() then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
