--Moon's Dream: Inside The Pot
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
	--Fragment creation
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+1000)
	e2:SetCondition(cid.fragcon)
	e2:SetTarget(cid.decktg)
	e2:SetOperation(cid.deckop)
	c:RegisterEffect(e2)
end
--filters
function cid.fragment(c)
	return c:IsCode(104242585) and c:IsFaceup()
end
function cid.filter(c)
	return c:IsAbleToDeck() and not c:IsCode(id)
end
function cid.fragcon(e,tp,eg,ep,ev,re,r,rp)
	return  tp==Duel.GetTurnPlayer() and Duel.GetTurnCount()~=e:GetHandler():GetTurnID() or e:GetHandler():IsReason(REASON_RETURN)
end
function cid.decktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cid.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cid.filter,tp,LOCATION_GRAVE,0,7,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cid.filter,tp,LOCATION_GRAVE,0,7,7,c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,7,0,0)
end
function cid.deckop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=7 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==7 and Duel.IsExistingMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		local frag=Duel.GetFirstMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,nil,e,tp)
		if frag and Duel.RemoveCards then
		Duel.RemoveCards(frag,nil,REASON_EFFECT+REASON_RULE)
		Duel.Remove(frag,POS_FACEUP,REASON_EFFECT) 
		end
			if frag and not Duel.RemoveCards then 
			Duel.Exile(frag,REASON_EFFECT+REASON_RULE)
			end
			
			Duel.Draw(tp,2,REASON_EFFECT)
end
end














function cid.cfilter2(c)
	return c:IsSetCard(0x666) and c:IsDiscardable()
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDiscardDeck(tp,2) and Duel.IsExistingMatchingCard(cid.cfilter2,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,cid.cfilter2,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,nil,2,REASON_EFFECT+REASON_DISCARD)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
end