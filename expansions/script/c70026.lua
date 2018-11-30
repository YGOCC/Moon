--"Espadachim - Mary, the Imperial Guard"
local m=70026
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Special Summon"
    local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetCountLimit(1,70026)
    e0:SetCondition(c70026.spcon)
    c:RegisterEffect(e0)
    --"Cannot Be Destroyed"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(c70026.efilter)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    c:RegisterEffect(e2)
    --"Level Change"
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_CHANGE_LEVEL)
    e3:SetCondition(c70026.lvcon)
    e3:SetValue(1)
    c:RegisterEffect(e3)
end
function c70026.spfilter(c)
    return c:IsFaceup() and c:IsCode(70024) or c:IsCode(70025)
end
function c70026.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c70026.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c70026.efilter(e,c)
    return c:IsCode(70024) or c:IsCode(70025)
end
function c70026.lvfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x509) and c:IsType(TYPE_TUNER)
end
function c70026.lvcon(e)
    return Duel.IsExistingMatchingCard(c70026.lvfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end