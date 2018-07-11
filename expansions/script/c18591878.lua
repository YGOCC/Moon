--Kid Ninja - The Challenger
function c18591878.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcCode3(c,18591874,18591875,18591872,true,true,true)
    --immune
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(c18591878.efilter)
    c:RegisterEffect(e4)
    --atk up
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(18591878,1))
    e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e5:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e5:SetCondition(c18591878.atkcon)
    e5:SetOperation(c18591878.atkop)
    c:RegisterEffect(e5)
end
function c18591878.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c18591878.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetBattleTarget()
end
function c18591878.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    local val=bc:GetAttack()+100
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