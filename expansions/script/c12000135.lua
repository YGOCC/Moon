--Teutonic Order - Dragonification
function c12000135.initial_effect(c)
	--Effect gain
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c12000135.efftg)
    e1:SetOperation(c12000135.effop)
    c:RegisterEffect(e1)
	--Draw 2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,12000135)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c12000135.thcost)
	e2:SetTarget(c12000135.target)
	e2:SetOperation(c12000135.thop)
	c:RegisterEffect(e2)
end
--Effect gain
function c12000135.efffilter(c)
    return c:IsFaceup() and c:IsSetCard(0x857) and c:IsType(TYPE_MONSTER)
end
function c12000135.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c12000135.efffilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c12000135.efffilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.SelectTarget(tp,c12000135.efffilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c12000135.effop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        --destroy replace
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EFFECT_DESTROY_REPLACE)
        e2:SetRange(LOCATION_MZONE)
        e2:SetTarget(c12000135.reptg)
        e2:SetValue(c12000135.repval)
        e2:SetOperation(c12000135.repop)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2)
    end
end
function c12000135.repfilter1(c)
    return (c:IsSetCard(0x857) and c:IsLocation(LOCATION_MZONE) and c:IsAbleToGrave())
        or (c:IsSetCard(0x857) and c:IsLocation(LOCATION_HAND) and c:IsAbleToGrave())
end
function c12000135.repfilter2(c,tp)
    return c:IsFaceup() and c:IsSetCard(0x857) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
        and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c12000135.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c12000135.repfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler())
        and eg:IsExists(c12000135.repfilter2,1,e:GetHandler(),tp) end
    return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c12000135.repval(e,c)
    return c12000135.repfilter2(c,e:GetHandlerPlayer())
end
function c12000135.repop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,c12000135.repfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler())
    Duel.SendtoGrave(g,REASON_EFFECT)
end
--Draw 2
function c12000135.cfilter(c)
	return c:IsSetCard(0x857) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c12000135.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c12000135.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c12000135.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c12000135.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c12000135.thop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end