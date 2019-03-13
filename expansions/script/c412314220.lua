--Drago Armageddon Occhi dell'Alba
--Created by Jake, Script by XGlitchy30
--Script by XGlitchy30
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),6,3,cid.ovfilter,aux.Stringid(id,0))
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.operation)
	c:RegisterEffect(e1)
end
--filters
function cid.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x613) and c:IsType(TYPE_XYZ)
end
function cid.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
--destroy
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(cid.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	if g:GetCount()>=2 then
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,PLAYER_ALL,math.floor(g:GetCount()/2))
	end
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cid.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if og:GetCount()>=2 then
		Duel.BreakEffect()
		local ct=math.floor(og:GetCount()/2)
		local ct2=ct
		if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<ct then ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0) end
		if Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)<ct2 then ct2=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0) end
		Duel.DiscardHand(tp,aux.TRUE,ct,ct,REASON_EFFECT+REASON_DISCARD,nil)
		Duel.DiscardHand(1-tp,aux.TRUE,ct2,ct2,REASON_EFFECT+REASON_DISCARD,nil)
	end
end