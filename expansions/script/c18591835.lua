--The Assassin Apprentice
function c18591835.initial_effect(c)
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(18591835,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLE_DAMAGE)
    e1:SetCondition(c18591835.atkcon)
    e1:SetOperation(c18591835.atkop)
    c:RegisterEffect(e1)
end
function c18591835.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp
end
function c18591835.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
        e1:SetValue(500)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
        c:RegisterEffect(e1)
    end
end
