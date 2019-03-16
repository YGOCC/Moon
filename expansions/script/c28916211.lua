--This file was automatically coded by Kinny's Numeron Code~!
local ref=_G['c'..28916211]
local id=28916211
function ref.initial_effect(c)
	--Effect 0
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,28916211)
	e0:SetTarget(ref.target0)
	e0:SetOperation(ref.operation0)
	c:RegisterEffect(e0)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,128916211)
	e1:SetTarget(ref.target1)
	e1:SetOperation(ref.operation1)
	c:RegisterEffect(e1)
end
function ref.SettableST(c)
	return c:IsType(TYPE_TRAP)
end
function ref.ToGY(c)
	return c:IsAbleToGrave()
end
function ref.target0(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(ref.SettableST,tp,LOCATION_GRAVE,0,1,nil) end
	if chkc then return ref.SettableST(chkc) and c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) end
	local g0 = Duel.SelectTarget(tp,ref.SettableST,tp,LOCATION_GRAVE,0,1,1,nil)
end
function ref.operation0(e,tp,eg,ep,ev,re,r,rp)
	local g0=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SSet(tp,g0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e1:SetValue(LOCATION_REMOVED)
	g0:GetFirst():RegisterEffect(e1)
end
function ref.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(ref.ToGY,tp,LOCATION_ONFIELD,0,1,nil) end
	if chkc then return ref.ToGY(chkc) and c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp) end
	local g0 = Duel.SelectTarget(tp,ref.ToGY,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g0,g0:GetFirst():GetControler(),g0:GetCount(),g0:GetFirst():GetLocation())
end
function ref.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g0=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Release(g0,REASON_EFFECT)~=0 then
		Duel.SSet(tp,c)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_DECKBOT)
		c:RegisterEffect(e1)
	end
end
