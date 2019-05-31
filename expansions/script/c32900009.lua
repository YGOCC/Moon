--Fae Requiem
function c32900009.initial_effect(c)
    --apply effect
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(32900009,0))
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,32900009)
    e1:SetTarget(c32900009.efftg)
    e1:SetOperation(c32900009.effop)
    c:RegisterEffect(e1)
    --To hand
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCost(aux.bfgcost)
    e4:SetTarget(c32900009.thtg)
    e4:SetOperation(c32900009.thop)
    c:RegisterEffect(e4)
end
function c32900009.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
    if not (c:IsSetCard(0x13b) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())) then return false end
    local m=_G["c"..c:GetCode()]
    if not m then return false end
    local te=m.banish_effect
    if not te then return false end
    local tg=te:GetTarget()
    return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c32900009.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c32900009.efffilter(chkc,e,tp,eg,ep,ev,re,r,rp) end
    if chk==0 then return Duel.IsExistingTarget(c32900009.efffilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
    if Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,32900001)>=3 then
        e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    else
        e:SetProperty(0)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c32900009.efffilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
    local tc=g:GetFirst()
    Duel.ClearTargetCard()
    tc:CreateEffectRelation(e)
    e:SetLabelObject(tc)
    local m=_G["c"..tc:GetCode()]
    local te=m.banish_effect
    local tg=te:GetTarget()
    if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c32900009.effop(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=e:GetLabelObject()
    if tc:IsRelateToEffect(e) then
        local m=_G["c"..tc:GetCode()]
        local te=m.banish_effect
        local op=te:GetOperation()
        if op then op(e,tp,eg,ep,ev,re,r,rp) end
        Duel.BreakEffect()
        local opt=Duel.SelectOption(tp,aux.Stringid(32900009,1),aux.Stringid(32900009,2))
        if opt==0 then
            Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
        else
            Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
        end
    end
end
function c32900009.thfilter(c)
    return c:IsSetCard(0x13b) and c:IsAbleToHand()
end
function c32900009.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c32900009.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c32900009.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c32900009.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c32900009.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end
end