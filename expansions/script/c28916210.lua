--This file was automatically coded by Kinny's Numeron Code~!
local ref=_G['c'..28916210]
local id=28916210
function ref.initial_effect(c)
	--Effect 0
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetCountLimit(1,28916210)
	e0:SetCondition(ref.actcon0)
	e0:SetTarget(ref.target0)
	e0:SetOperation(ref.operation0)
	c:RegisterEffect(e0)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,128916210)
	e1:SetCondition(ref.condition1)
	e1:SetTarget(ref.target1)
	e1:SetOperation(ref.operation1)
	c:RegisterEffect(e1)
end
function ref.IsBanishable(c)
	return c:IsAbleToRemove()
end
function ref.ToGY(c)
	return c:IsAbleToGrave()
end
function ref.actcon0(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER) and re:GetHandlerPlayer()~=tp
end
function ref.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.IsBanishable,tp,0,LOCATION_DECK,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,ct,1-tp,LOCATION_DECK)
end
function ref.operation0(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.NegateEffect(ev) then
		local g1 = Duel.GetDecktopGroup(1-tp,ct)
		Duel.Remove(g1,POS_FACEDOWN,REASON_EFFECT)
	end
end
function ref.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not (Duel.GetCurrentChain()>=1)
end
function ref.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(ref.ToGY,tp,LOCATION_ONFIELD,0,1,nil) end
	if chkc then return ref.ToGY(chkc) and c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp) end
	local g0 = Duel.SelectTarget(tp,ref.ToGY,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g0,g0:GetFirst():GetControler(),g0:GetCount(),g0:GetFirst():GetLocation())
end
function ref.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g0 = Duel.GetFirstTarget()
	if Duel.Release(g0,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_DECKBOT)
		c:RegisterEffect(e1)
	end
end
