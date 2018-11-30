--"Temple of the Espadachins"
local m=70011
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Activate"
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --"Pierce"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_PIERCE)
    e1:SetRange(LOCATION_FZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x509))
    c:RegisterEffect(e1)
    --"To hand"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(70011,0))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c70011.thtg2)
    e2:SetOperation(c70011.thop2)
    c:RegisterEffect(e2)
    --"ATK UP"
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetRange(LOCATION_FZONE)
    e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e3:SetCondition(c70011.atkcon)
    e3:SetTarget(c70011.atktg)
    e3:SetValue(c70011.atkval)
    c:RegisterEffect(e3)
end
function c70011.thfilter(c)
    return (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x509)) or c:IsSetCard(0x510) and c:IsAbleToDeck()
end
function c70011.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c70011.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c70011.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c70011.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c70011.thop2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsAbleToDeck() then Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
    end
end
function c70011.atkcon(e)
    c70011[0]=false
    return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end
function c70011.atktg(e,c)
    return c==Duel.GetAttacker() and c:IsSetCard(0x509)
end
function c70011.atkval(e,c)
    local d=Duel.GetAttackTarget()
    if c70011[0] or c:GetAttack()<d:GetAttack() then
        c70011[0]=true
        return 500
    else return 0 end
end