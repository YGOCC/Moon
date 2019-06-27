--Star Bear's Lightsworn
local m=888700
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DISABLE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BE_MATERIAL)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,8887002)
    e2:SetCondition(cm.tgcon)
    e2:SetOperation(cm.sumsuc)
    c:RegisterEffect(e2)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(23064604,2))
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetCountLimit(1,8887004)
    e4:SetCondition(cm.thcon)
    e4:SetCost(cm.thcost)
    e4:SetTarget(cm.thtg)
    e4:SetOperation(cm.thop)
    c:RegisterEffect(e4)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return Duel.GetTurnPlayer()~=tp 
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    return c:IsLocation(LOCATION_GRAVE) and rc:IsSetCard(0xff1) and r&REASON_FUSION~=0
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DISABLE)
    e2:SetTargetRange(0,LOCATION_GRAVE)
    e2:SetTarget(cm.disable)
    e2:SetReset(RESET_PHASE+PHASE_END)
    e2:SetLabel(c:GetFieldID())
    Duel.RegisterEffect(e2,tp)
end
function cm.disable(e,c)
    return c:GetFieldID()~=e:GetLabel() and (not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT))
end
function cm.cfilter(c)
    return c:IsSetCard(0xff1) and c:IsDiscardable()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,cm.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function cm.thfilter(c)
    return c:IsSetCard(0xff1) and c:IsType(TYPE_MONSTER)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end