--Kumicho Dokurider Cherry
--Script by TaxingCorn117
function c66823467.initial_effect(c)
    c:EnableReviveLimit()
    --code
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_CHANGE_CODE)
    e1:SetRange(LOCATION_HAND)
    e1:SetValue(99721536)
    c:RegisterEffect(e1)
    --attack up
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(66823467,0))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_BATTLE_START)
    e2:SetCondition(c66823467.condition)
    e2:SetOperation(c66823467.operation)
    c:RegisterEffect(e2)
    --to hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(66823467,1))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetTarget(c66823467.thtg)
    e3:SetOperation(c66823467.thop)
    c:RegisterEffect(e3)
end
--filters
function c66823467.filter(c)
    return (c:IsCode(99721536) or c:IsCode(31066283) or c:IsSetCard(0x1e0)) and c:IsAbleToHand()
end
--attack up
function c66823467.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsRelateToBattle()
end
function c66823467.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(200)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
        c:RegisterEffect(e1)
    end
end
--to hand
function c66823467.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c66823467.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c66823467.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c66823467.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c66823467.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end
