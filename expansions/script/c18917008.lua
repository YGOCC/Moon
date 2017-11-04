--Lyrica's Scepter
local ref=_G['c'..18917008]
function ref.initial_effect(c)
	--Attach
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(ref.cost)
	e1:SetTarget(ref.target)
	e1:SetOperation(ref.activate)
	c:RegisterEffect(e1)
	--Shuffle
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(ref.drcost)
	e2:SetTarget(ref.drtg)
	e2:SetOperation(ref.drop)
	c:RegisterEffect(e2)
end

function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function ref.filter(c)
	return c:IsFaceup() and c.transform
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and ref.filter(chkc) end
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingTarget(ref.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,ref.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function ref.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
		c:CancelToGrave()
		Duel.Overlay(tc,Group.FromCards(c))
	end
end

function ref.tdfilter(c)
	return c.transform and c:IsAbleToExtraAsCost()
end
function ref.drcost(e,tp,ev,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(ref.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local cc=Duel.SelectMatchingCard(tp,ref.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	local g=Group.FromCards(c,cc)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function ref.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function ref.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,2,REASON_EFFECT) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end
