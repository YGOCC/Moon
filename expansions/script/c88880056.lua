--Number U301: Neon Galaxy-Eyes Photonic Creation Dragon
function c88880056.initial_effect(c)
    c:EnableReviveLimit()
    aux.EnablePendulumAttribute(c)
    --ATK/DEF gain
    local ep0=Effect.CreateEffect(c)
    ep0:SetType(EFFECT_TYPE_FIELD)
    ep0:SetCode(EFFECT_UPDATE_ATTACK)
    ep0:SetRange(LOCATION_PZONE)
    ep0:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    ep0:SetTarget(c88880022.mod1filter)
    ep0:SetValue(c88880022.mod1val)
    c:RegisterEffect(ep0)
    local ep1=ep0:Clone()
    ep1:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(ep1)
    --spsummon limit
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(c88880056.splimit)
    c:RegisterEffect(e0)
    --This card's Xyz Summon cannot be negated. 
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCondition(c88880056.effcon)
    c:RegisterEffect(e1)
end
c88880056.xyz_number=301
--ATK gain
function c88880022.mod1filter(e,c)
    return c:IsType(TYPE_MONSTER)
end
function c88880022.mod1val(e,c)
    return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_REMOVED,0)*500
end
--spsummon limit
function c88880056.splimit(e,se,sp,st)
    return se:GetHandler():IsCode(88880045) and se:GetHandler():IsType(TYPE_SPELL)
end
--Xyz Summon cannot be negated
function c88880056.effcon(e)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
--