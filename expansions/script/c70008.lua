--"Frosty Espadachim"
local m=70008
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Special Summon"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(70008,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,70008)
    e1:SetCondition(c70008.spcon)
    c:RegisterEffect(e1)
    --"Gains 100 ATK"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(70008,1))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c70008.ATKcon)
    e2:SetOperation(c70008.ATKop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --"Destroy"
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(70008,2))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_BATTLE_DESTROYED)
    e4:SetCondition(c70008.condition)
    e4:SetTarget(c70008.target)
    e4:SetOperation(c70008.operation)
    c:RegisterEffect(e4)
end
function c70008.spfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x509)
end
function c70008.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c70008.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c70008.ATKfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0x509) and c:IsControler(tp)
end
function c70008.ATKcon(e,tp,eg,ep,ev,re,r,rp)
    return not eg:IsContains(e:GetHandler()) and eg:IsExists(c70008.ATKfilter,1,nil,tp)
end
function c70008.ATKop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(100)
        c:RegisterEffect(e1)
    end
end
function c70008.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
        and e:GetHandler():GetReasonCard():IsRelateToBattle()
end
function c70008.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local rc=e:GetHandler():GetReasonCard()
    rc:CreateEffectRelation(e)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
end
function c70008.operation(e,tp,eg,ep,ev,re,r,rp)
    local rc=e:GetHandler():GetReasonCard()
    if rc:IsRelateToEffect(e) then
        Duel.Destroy(rc,REASON_EFFECT)
    end
end