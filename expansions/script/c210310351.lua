--The Nephological Ghost King - Tree
local card = c210310351
function card.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),8,2,card.ovfilter,aux.Stringid(210310351,0),2,card.xyzop)
	aux.EnablePendulumAttribute(c,false)
	--no level place counters
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(210310351,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c210310351.targetz)
	e1:SetOperation(c210310351.operationz)
	c:RegisterEffect(e1)
	--Remove counter to draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(210310351,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCost(c210310351.drcost)
	e2:SetTarget(c210310351.drtg)
	e2:SetOperation(c210310351.drop)
	c:RegisterEffect(e2)
	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--selfdes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(card.sdcon)
	c:RegisterEffect(e4)
	--Xyz Summon Success
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(210310351,0))
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(card.condition)
	e5:SetOperation(card.operation)
	c:RegisterEffect(e5)
	--detach
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(210310351,0))
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCost(card.descost)
	e6:SetTarget(card.destg)
	e6:SetOperation(card.desop)
	c:RegisterEffect(e6)
	--to pendulum Zone
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetOperation(card.penop)
	e7:SetCondition(card.descon1)
	e7:SetTarget(card.pentg)
	c:RegisterEffect(e7)
	
end
function card.ovfilter(c)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_XYZ) and (rk==4)
end
function card.xyzop(e,tp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(210310351,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end
--no level place counters
function c210310351.targetz(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c210310351.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c210310351.filter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c210310351.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c210310351.operationz(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        tc:AddCounter(0x1019,4)
    end
end
--Remove counter to draw
function c210310351.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1019,3,REASON_COST) end
	RemoveCounter(tp,0x1019,3,REASON_COST)
end
function c210310351.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c210310351.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
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
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
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
	function card.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return (chkc:IsOnField() and chkc:IsControler(1-tp) and card.desfilter(chkc)) and (chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and card.filter1(chkc)) end
    if chk==0 then return Duel.IsExistingTarget(card.desfilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingTarget(card.filter1,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local gg=Duel.SelectTarget(tp,card.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,gg,1,0,0)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local ggg=Duel.SelectTarget(tp,card.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,ggg,ggg:GetCount(),0,0)
end
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

function card.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function card.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end