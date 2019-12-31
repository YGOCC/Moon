--created by Zolanark, coded by Lyris
local cid,id=GetID()
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetCost(cid.pcost)
	e1:SetTarget(cid.ptg)
	e1:SetOperation(cid.pop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
	e2:SetCost(cid.mcost)
	e2:SetTarget(cid.mtg)
	e2:SetOperation(cid.mop)
	c:RegisterEffect(e2)
end
function cid.cfilter(c,ec)
	return c:IsDestructable() and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,Group.FromCards(c,ec))
end
function cid.pcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(9)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_ATTACK)==0 and c:IsDestructable() and Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,cid.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,c)+c
	Duel.Destroy(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cid.ptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() end
	if chk==0 then
		if e:GetLabel()==9 then
			e:SetLabel(0)
			if not Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then return false end
		end
		return Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cid.pop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_DECK) then return end
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.Draw(tp,2,REASON_EFFECT)
end
function cid.mcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable() end
	Duel.Destroy(c,REASON_COST)
end
function cid.mtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,g:GetFirst():GetOwner(),200)
end
function cid.mop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local p=tc:GetOwner()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,p,2,REASON_EFFECT) and tc:IsLocation(LOCATION_DECK) then
		Duel.Damage(p,200,REASON_EFFECT)
	end
end
