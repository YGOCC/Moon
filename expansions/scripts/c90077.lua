--"Hacker - Data Destroyer"
local m=90077
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Synchro Material"
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1aa),aux.NonTuner(nil),1)
    c:EnableReviveLimit()
    --"ATK UP"
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e0:SetRange(LOCATION_MZONE)
    e0:SetCode(EFFECT_UPDATE_ATTACK)
    e0:SetValue(c90077.val)
    c:RegisterEffect(e0)
    --"Negate effects"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90077,0))
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLE_CONFIRM)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c90077.target)
    e1:SetOperation(c90077.operation)
    c:RegisterEffect(e1)
    --"Destroy"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90077,1))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c90077.descon)
    e2:SetTarget(c90077.destg)
    e2:SetOperation(c90077.desop)
    c:RegisterEffect(e2)
end
function c90077.atkfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x1aa)
end
function c90077.val(e,c)
    return Duel.GetMatchingGroupCount(c90077.atkfilter,0,LOCATION_MZONE,LOCATION_MZONE,c)*800
end
function c90077.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_MZONE,1,nil) end
end
function c90077.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
end
function c90077.cfilter(c,tp)
    return c:IsPreviousLocation(LOCATION_DECK) and c:GetPreviousControler()==tp
end
function c90077.descon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c90077.cfilter,1,nil,1-tp)
end
function c90077.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c90077.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end