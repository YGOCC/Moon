--Draquis, the Protector Dragon
function c15052340.initial_effect(c)
    --attack sp
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(15052340,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c15052340.condition)
    e1:SetTarget(c15052340.target)
    e1:SetOperation(c15052340.operation)
    c:RegisterEffect(e1)
   --Special Summon on Activation
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(15052340,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c15052340.condition2)
    e2:SetTarget(c15052340.target)
    e2:SetOperation(c15052340.operation)
    c:RegisterEffect(e2)
    --Negate
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(15052340,0))
    e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_CHAINING)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c15052340.condition3)
    e3:SetCost(c15052340.cost)
    e3:SetTarget(c15052340.target2)
    e3:SetOperation(c15052340.operation2)
    c:RegisterEffect(e3)
    --battle indes
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e4:SetCountLimit(1)
    e4:SetValue(c15052340.valcon)
    c:RegisterEffect(e4)
    --avoid battle damage
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WYRM))
    e5:SetValue(1)
    c:RegisterEffect(e5)
end
function c15052340.valcon(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0
end
function c15052340.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker():IsControler(1-tp)
end
function c15052340.condition2(e,tp,eg,ep,ev,re,r,rp)
return ep~=tp
end
function c15052340.condition3(e,tp,eg,ep,ev,re,r,rp)
    return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c15052340.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,0,2,2,nil)
    Duel.Destroy(g,REASON_COST)
end
function c15052340.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c15052340.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e)  then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c15052340.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c15052340.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
end