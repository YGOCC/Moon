--Kid Ninja - The Challenger
function c18591878.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x2b),4,true)
    --immune
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(2)
    e1:SetValue(c18591878.efilter)
    c:RegisterEffect(e1)
    --atk up
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(18591878,1))
    e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e2:SetCountLimit(1)
    e2:SetCondition(c18591878.condition)
    e2:SetOperation(c18591878.operation)
    c:RegisterEffect(e2)
    --battle indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e3:SetCountLimit(1)
    e3:SetValue(c18591878.valcon)
    c:RegisterEffect(e3)
    --atk
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(18591878,0))
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_DAMAGE)
    e4:SetCondition(c18591878.atkcon)
    e4:SetOperation(c18591878.atkop)
    c:RegisterEffect(e4)
end
c18591878.material_setcode=0x2b
function c18591878.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c18591878.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetBattleTarget()
end
function c18591878.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    local val=bc:GetAttack()+500
    if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
        e1:SetValue(val)
        c:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
        c:RegisterEffect(e2)
    end
end
function c18591878.valcon(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0
end
function c18591878.atkcon(e,tp,eg,ep,ev,re,r,rp)
    if ep~=tp then return false end
    if bit.band(r,REASON_EFFECT)~=0 then return rp==1-tp end
    return e:GetHandler():IsRelateToBattle()
end
function c18591878.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(ev)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
        c:RegisterEffect(e1)
    end
end