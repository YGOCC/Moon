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
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
	--Fragment creation
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(cid.fragop)
	c:RegisterEffect(e2)
end
--Filters
function cid.filter(c)
	return c:IsSetCard(0x666) and c:IsAbleToDeck()
end
function cid.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
--effect 1
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cid.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cid.filter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cid.filter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(44335251,2))
	local g=Duel.SelectMatchingCard(tp,cid.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local a=tc:IsAbleToHand()
		local b=tc:IsAbleToGrave()
if chk==0 then return a or b end
if a and b then
    op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
elseif a then
    op=0
elseif b then
    op=1
end
if op==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			local g1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			local sg=g1:Filter(Card.IsRelateToEffect,nil,e)
			if sg:GetCount()>0 then
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
			end
			
			end
if op==1 then
			Duel.SendtoGrave(tc,REASON_EFFECT)
			local g1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			local sg=g1:Filter(Card.IsRelateToEffect,nil,e)
			if sg:GetCount()>0 then
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
			tc:IsAbleToGrave()
end
			
end
end
end


function cid.fragop(e,tp,eg,ep,ev,re,r,rp,chk)	
		local sc=Duel.CreateToken(tp,104242585)
		sc:SetCardData(CARDDATA_TYPE,sc:GetType()-TYPE_TOKEN)
		Duel.SendtoExtraP(sc,tp,REASON_RULE)
end
