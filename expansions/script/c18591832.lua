--Brian, The Relentless Assassin
function c18591832.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e1:SetCondition(c18591832.atkcon)
    e1:SetOperation(c18591832.atkop)
    c:RegisterEffect(e1)
    --double attack
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EXTRA_ATTACK)
    e2:SetValue(1)
    c:RegisterEffect(e2)
end
function c18591832.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c==Duel.GetAttacker() or (Duel.GetAttackTarget() and c==Duel.GetAttackTarget())
end
function c18591832.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1000)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        c:RegisterEffect(e1)
    end
end
