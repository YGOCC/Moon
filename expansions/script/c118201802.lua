local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
--created by Zolanark, coded by Lyris
--Arthro-Lord, Venogust
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e1:SetCondition(cid.pcon)
	e1:SetCost(cid.pcost)
	e1:SetTarget(cid.ptg)
	e1:SetOperation(cid.pop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e2:SetTarget(cid.mtg)
	e2:SetOperation(cid.mop)
	c:RegisterEffect(e2)
end
function cid.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function cid.pcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cid.cfilter,1,nil,1-tp)
end
function cid.cfilter2(c)
	return c:IsSetCard(0x89f) and c:IsDestructable()
end
function cid.pcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable() and Duel.IsExistingMatchingCard(cid.cfilter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,cid.cfilter2,tp,LOCATION_HAND,0,1,1,nil)+c
	Duel.Destroy(g,REASON_COST)
end
function cid.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>1 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,1-tp,LOCATION_HAND)
end
function cid.filter(c)
	return c:IsSetCard(0x89f) and c:IsAbleToHand()
end
function cid.pop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)<2 then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,2)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)<2 or g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<2 then return end
	local dg=Duel.GetMatchingGroup(cid.filter,tp,LOCATION_DECK,0,nil)
	if #dg>0 and Duel.SelectYesNo(tp,1109) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=dg:Select(tp,1,1,nil)
		Duel.BreakEffect()
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cid.mtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable() and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*300)
end
function cid.mop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
		local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.Recover(tp,ct*300,REASON_EFFECT)
	end
end
