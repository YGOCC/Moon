--"Litus, The God Of The Assassins"
local m=18591824
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Fusion Materials"
    c:EnableReviveLimit()
    aux.AddFusionProcCode2(c,18591823,18591821,true,true)
    --negate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(18591824,0))
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_BATTLED)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c18591824.distg)
    e1:SetOperation(c18591824.disop)
    c:RegisterEffect(e1)    
    --immune
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c18591824.efilter)
    c:RegisterEffect(e2)
    --attack all
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_ATTACK_ALL)
    e4:SetValue(1)
    c:RegisterEffect(e4)
end
function c18591824.efilter(e,te)
    return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c18591824.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c18591824.disop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    local c=e:GetHandler()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_PHASE+PHASE_DAMAGE,0,1)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_PHASE+PHASE_DAMAGE,0,1)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
end