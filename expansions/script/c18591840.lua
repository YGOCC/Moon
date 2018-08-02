--DIMITRI, THE SUCCESSFUL KILLER
function c18591840.initial_effect(c)
    --Link summon
    aux.AddLinkProcedure(c,c18591840.matfilter,3)
    c:EnableReviveLimit()
    --atk
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c18591840.atkval)
    c:RegisterEffect(e1)
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetCondition(c18591840.indcon)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetValue(aux.indoval)
    c:RegisterEffect(e3)
end
function c18591840.matfilter(c)
    return c:IsSetCard(0x50e)
end
function c18591840.atkval(e,c)
    return c:GetLinkedGroupCount()*500
end
function c18591840.indcon(e)
    return e:GetHandler():GetLinkedGroupCount()>0
end