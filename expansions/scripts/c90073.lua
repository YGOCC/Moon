--"Hacker - Blocker, The Cracking Creator"
local m=90073
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Fusion Materials"
    aux.AddFusionProcFunFunRep(c,c90073.mfilter1,c90073.mfilter2,3,63,true)
    c:EnableReviveLimit()
    --"Multi Attack"
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e0:SetCode(EVENT_SPSUMMON_SUCCESS)
    e0:SetCondition(c90073.mtcon)
    e0:SetOperation(c90073.mtop)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_MATERIAL_CHECK)
    e1:SetValue(c90073.valcheck)
    e1:SetLabelObject(e0)
    c:RegisterEffect(e1)
    --"Cannot Attack"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_ATTACK)
    e2:SetCondition(c90073.atcon)
    c:RegisterEffect(e2)
    --"Attack Cost"
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_ATTACK_COST)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(0,1)
    e3:SetCost(c90073.atcost)
    e3:SetOperation(c90073.atop)
    c:RegisterEffect(e3)
    --"Accumulate"
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(0x10000000+90073)
    e4:SetRange(LOCATION_MZONE)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(0,1)
    c:RegisterEffect(e4)
    --"Negate & Destroy"
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_CHAINING)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCondition(c90073.condition)
    e5:SetCost(c90073.cost)
    e5:SetTarget(c90073.target)
    e5:SetOperation(c90073.operation)
    c:RegisterEffect(e5)
    --"Cannot Special Summon"
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(90073,0))
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_DAMAGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(c90073.dcon)
    e6:SetOperation(c90073.dop)
    c:RegisterEffect(e6)
end
c90073.material_setcode=0x1aa
function c90073.mfilter1(c)
    return c:IsFusionSetCard(0x1aa) and c:IsType(TYPE_LINK)
end
function c90073.mfilter2(c)
    return c:IsFusionSetCard(0x1aa) and c:IsType(TYPE_NORMAL)
end
function c90073.mfilter(c)
    return c:IsType(TYPE_PENDULUM)
end
function c90073.valcheck(e,c)
    local g=c:GetMaterial()
    local ct=g:FilterCount(c90073.mfilter,nil)
    e:GetLabelObject():SetLabel(ct)
end
function c90073.mtcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()>0
end
function c90073.mtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=e:GetLabel()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EXTRA_ATTACK)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
    e1:SetValue(ct-1)
    c:RegisterEffect(e1)
end
function c90073.atcon(e)
    return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>1
end
function c90073.atcost(e,c,tp)
     return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil)
end
function c90073.atop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c90073.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c90073.cfilter(c)
    return c:IsSetCard(0x1aa) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c90073.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c90073.cfilter,1,nil) end
    local g=Duel.SelectReleaseGroup(tp,c90073.cfilter,1,1,nil)
    Duel.Release(g,REASON_COST)
end
function c90073.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c90073.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
function c90073.dcon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and bit.band(r,REASON_EFFECT)~=0 and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x1aa)
end
function c90073.dop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(0,1)
    e1:SetTarget(c90073.sumlimit)
    Duel.RegisterEffect(e1,tp)
end
function c90073.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return c:IsLocation(LOCATION_EXTRA)
end