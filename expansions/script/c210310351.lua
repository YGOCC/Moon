--The Nephological Ghost King - Tree
local card = c210310351
function card.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),8,2,card.ovfilter,aux.Stringid(210310351,0),2,card.xyzop)
	aux.EnablePendulumAttribute(c,false)
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--selfdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(card.sdcon)
	c:RegisterEffect(e2)
	--Xyz Summon Success
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(210310351,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(card.condition)
	e3:SetOperation(card.operation)
	c:RegisterEffect(e3)
	--detach
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(210310351,0))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCost(card.descost)
	e4:SetTarget(card.destg)
	e4:SetOperation(card.desop)
	c:RegisterEffect(e4)
	--to pendulum Zone
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetOperation(card.desop1)
	e5:SetCondition(card.descon1)
	e5:SetTarget(card.destg1)
	c:RegisterEffect(e5)
	
end
function card.ovfilter(c)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_XYZ) and (rk==4)
end
function card.xyzop(e,tp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(210310351,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end
--selfdes
function card.sdcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
end
--Xyz Summon Success
function card.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function card.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1019,1)
		tc=g:GetNext()
	end
end
--detach
function card.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function card.desfilter(c)
	return c:IsFaceup() and c:GetCounter(0x1019)>0
end
function card.filter1(c)
	return c:IsAbleToDeck()
end
function card.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and card.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(card.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,card.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and card.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(card.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,card.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function card.desop(e,tp,eg,ep,ev,re,r,rp)
	local x,tc1=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local tc=tc1:GetFirst()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	local x,tg1=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	local tg=tg1:GetFirst()
	if tg:IsRelateToEffect(e) then
		Duel.SendtoDeck(tg,nil,0,REASON_EFFECT) end
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
	end
end
--to pendulum zone
function card.descon1(e,tp,eg,ep,ev,re,r,rp)
    return not re or re:GetOwner()~=c
end

function card.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)	end
end

function card.desop1(e,tp,eg,ep,ev,re,r,rp)
    Debug.Message("Part 1: "..tostring(not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1)))
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    Debug.Message("Part 2: "..tostring(c:IsRelateToEffect(e)))
    if c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() then
        Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    end
end