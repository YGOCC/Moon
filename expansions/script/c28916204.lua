--This file was automatically coded by Kinny's Numeron Code~!
local ref=_G['c'..28916204]
local id=28916204
function ref.initial_effect(c)
	c:EnableReviveLimit()
	--Effect 0
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,28916204)
	e0:SetCost(ref.cost0)
	e0:SetTarget(ref.target0)
	e0:SetOperation(ref.operation0)
	c:RegisterEffect(e0)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,128916204)
	e1:SetTarget(ref.rmtg)
	e1:SetOperation(ref.rmop)
	c:RegisterEffect(e1)
end
function ref.CanGY(c)
	return c:IsAbleToGrave()
end
function ref.Search(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(1858) and c:IsAbleToHand()
end
function ref.cost0(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return ref.CanGY(c) end
	Duel.SendtoGrave(c,REASON_COST)
end
function ref.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.Search,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0)
end
function ref.operation0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1 = Duel.SelectMatchingCard(tp,ref.Search,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,g1)
	end
end

function ref.rmfilter(c)
	return (c:IsLocation(LOCATION_HAND) and c:IsDiscardable())
		or (c:IsLocation(LOCATION_GRAVE+LOCATION_DECK) and c:IsAbleToRemove(c:GetControler()))
end
function ref.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,nil,0,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,nil,0,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function ref.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsFacedown,1-tp,LOCATION_REMOVED,0,nil)
	local g=Duel.GetMatchingGroup(ref.rmfilter,1-tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:Select(1-tp,ct,ct,nil)
		local hg=sg:Filter(Card.IsLocation,nil,LOCATION_HAND)
		local gg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		local dg=sg:Filter(Card.IsLocation,nil,LOCATION_DECK)
		if dg:GetCount()>0 then
			Duel.Remove(dg,POS_FACEDOWN,REASON_RULE,1-tp)
		end
		if gg:GetCount()>0 then
			Duel.Remove(gg,POS_FACEUP,REASON_RULE,1-tp)
		end
		if hg:GetCount()>0 then
			Duel.SendtoGrave(hg,REASON_RULE+REASON_DISCARD,1-tp)
		end
	end
end
