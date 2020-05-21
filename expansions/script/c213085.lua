--Eternnal Odyssey
function c213085.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c213085.drtg)
	e1:SetOperation(c213085.drop)
	e1:SetCountLimit(1,213085+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
function c213085.drfilter(c)
	return c:IsSetCard(0x2700) and c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c213085.ctfilter(c)
	return c:IsFaceup() and c:IsCode(213080)
end
function c213085.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=1
	if Duel.IsExistingMatchingCard(c213085.ctfilter,tp,LOCATION_ONFIELD,0,1,nil) then ct=2 end
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c213085.drfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) and Duel.IsExistingTarget(c213085.drfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,5,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c213085.drfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,5,5,nil)
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c213085.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg and tg:FilterCount(Card.IsRelateToEffect,nil,e)~=0 then
		Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct>0 then
			Duel.BreakEffect()
			Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
		end
	end
end