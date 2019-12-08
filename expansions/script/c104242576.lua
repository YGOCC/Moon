--Moon's Dream: Renewal
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--special summon
	local exx=Effect.CreateEffect(c)
	exx:SetCategory(CATEGORY_TOHAND)
	exx:SetType(EFFECT_TYPE_IGNITION)
	exx:SetRange(LOCATION_GRAVE)
	exx:SetCondition(cid.spcon2)
	exx:SetTarget(cid.thtg)
	exx:SetOperation(cid.thop)
	c:RegisterEffect(exx)
			--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cid.drawtarget)
	e1:SetOperation(cid.drawop)
	c:RegisterEffect(e1)

end
--2 to deck, draw 1
function cid.todeckfilter(c)
	return c:IsAbleToDeck()
end
function cid.drawtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cid.todeckfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(cid.todeckfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cid.todeckfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
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
	Duel.Draw(tp,1,REASON_EFFECT)
end
end
--recursion
function cid.spcfilter2(c)
	return c:IsCode(104242585) and c:IsFaceup()
end
function cid.spcon2(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(cid.spcfilter2,tp,LOCATION_REMOVED,0,2,nil)
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.GetFirstMatchingCard(cid.spcfilter2,tp,LOCATION_REMOVED,0,nil,e,tp)
	if tc then
	if Duel.Exile(tc,REASON_RULE) then
	tc=Duel.GetFirstMatchingCard(cid.spcfilter2,tp,LOCATION_REMOVED,0,nil,e,tp)
	if tc then
	if Duel.Exile(tc,REASON_RULE) then
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
	end
	end
end
end
end