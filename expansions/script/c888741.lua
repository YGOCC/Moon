--Star Bearer's Veil
local m=888741
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_STEP)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
    --act in hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e2:SetCondition(cm.handcon)
    c:RegisterEffect(e2) 
    --bfg
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(cm.bthtg)
    e2:SetOperation(cm.bthop)
    c:RegisterEffect(e2)
end

function cm.handcon(e)
    return Duel.IsExistingMatchingCard(cm.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.cfilter(c)
    return c:IsSetCard(0xff1) and c:IsType(TYPE_FUSION)
end
function cm.filter(c)
    return c:IsSetCard(0xff1) and c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e2:SetValue(1)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
        e3:SetValue(1)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e3)
    end
end
function cm.filter2(c)
    return c:IsSetCard(0xff1) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.bthtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function cm.bthop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_REMOVED,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end