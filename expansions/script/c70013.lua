--"Espadachim - Cutting Master"
local m=70013
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Fusion Materials"
    c:EnableReviveLimit()
    aux.AddFusionProcCodeFun(c,c70013.ffilter,aux.FilterBoolFunction(Card.IsSetCard,0x509),2,true,true)
    --"Special Summon Condition"
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(c70013.splimit)
    c:RegisterEffect(e0)
    --"Negate"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(70013,0))
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCondition(c70013.discon)
    e1:SetTarget(c70013.distg)
    e1:SetOperation(c70013.disop)
    c:RegisterEffect(e1)
    --"Extra Attack"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EXTRA_ATTACK)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --"Equip"
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(70013,1))
    e3:SetCategory(CATEGORY_EQUIP)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c70013.eqtg)
    e3:SetOperation(c70013.eqop)
    c:RegisterEffect(e3)
end
c70013.espadachim_fusion=true
function c70013.splimit(e,se,sp,st)
    if e:GetHandler():IsLocation(LOCATION_EXTRA) then 
        return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
    end
    return true
end
function c70013.ffilter(c)
    return c:IsFusionType(TYPE_LINK) and c:IsSetCard(0x509)
end
function c70013.discon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
        and ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c70013.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c70013.disop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
function c70013.filter(c,rc,tid)
    return c:IsReason(REASON_BATTLE) and c:GetReasonCard()==rc and c:GetTurnID()==tid and not c:IsForbidden()
end
function c70013.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(c70013.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e:GetHandler(),Duel.GetTurnCount())
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,g:GetCount(),0,0)
end
function c70013.eqop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    if ft<=0 then return end
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    local g=Duel.GetMatchingGroup(c70013.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e:GetHandler(),Duel.GetTurnCount())
    if g:GetCount()==0 then return end
    if g:GetCount()>ft then return end
    local tc=g:GetFirst()
    while tc do
        Duel.Equip(tp,tc,c,false,true)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c70013.eqlimit)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_EQUIP)
        e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
        e2:SetCode(EFFECT_UPDATE_ATTACK)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        e2:SetValue(300)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
    Duel.EquipComplete()
end
function c70013.eqlimit(e,c)
    return e:GetOwner()==c
end