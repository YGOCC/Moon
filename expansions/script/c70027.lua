--"Marius Santana, the Supreme Espadachim of the Imperial Guard"
local m=70027
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Fusion Materials"
    c:EnableReviveLimit()
    aux.AddFusionProcMix(c,true,true,70024,70025,70026)
    --"Special Summon"
    local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(aux.fuslimit)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e1)
    --"Summon Success"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(c70027.sumsuc)
    c:RegisterEffect(e2)
    --"Direct Attack"
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_DIRECT_ATTACK)
    e4:SetCondition(c70027.dircon)
    c:RegisterEffect(e4)
    --"Cannot Be Destroyed"
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(c70027.efilter)
    e5:SetValue(1)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    c:RegisterEffect(e6)
    --"Negate"
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetCode(EVENT_CHAINING)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(c70027.condition)
    e7:SetCost(c70027.cost)
    e7:SetTarget(c70027.target)
    e7:SetOperation(c70027.operation)
    c:RegisterEffect(e7)
    --"ATK UP"
     local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCode(EFFECT_UPDATE_ATTACK)
    e8:SetValue(c70027.value)
    c:RegisterEffect(e8)
end
function c70027.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) then return end
    Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c70027.efilter(e,c)
    return (c:IsSetCard(0x509) and c:IsType(TYPE_MONSTER))
end
function c70027.dirfilter1(c)
    return c:IsFaceup() and c:IsCode(70011)
end
function c70027.dirfilter2(c)
    return c:IsFaceup() and c:IsAttackAbove(2500)
end
function c70027.dircon(e)
    return Duel.IsExistingMatchingCard(c70027.dirfilter1,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
        and not Duel.IsExistingMatchingCard(c70027.dirfilter2,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c70027.condition(e,tp,eg,ep,ev,re,r,rp)
   return ep~=tp and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c70027.cfilter(c)
    return c:IsSetCard(0x509) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c70027.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c70027.cfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c70027.cfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c70027.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c70027.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetTargetRange(0,1)
    e1:SetValue(c70027.aclimit)
    e1:SetLabel(re:GetHandler():GetCode())
    Duel.RegisterEffect(e1,tp)
end
function c70027.aclimit(e,re,tp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(e:GetLabel())
end
function c70027.value(e,c)
    return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_REMOVED,0)*100
end