--Exostorm Heavy Weapon
function c27084913.initial_effect(c)
    c:SetUniqueOnField(1,0,27084913)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,27084913)
    e1:SetCondition(c27084913.spcon)
    e1:SetOperation(c27084913.spop)
    c:RegisterEffect(e1)
    --remove
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(27084913,1))
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c27084913.rmcost)
    e2:SetTarget(c27084913.rmtg)
    e2:SetOperation(c27084913.rmop)
    c:RegisterEffect(e2)
end
function c27084913.spfilter(c)
    return c:IsSetCard(0xc1c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c27084913.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c27084913.spfilter,tp,LOCATION_DECK,0,1,nil)
end
function c27084913.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c27084913.spfilter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c27084913.cfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc1c) and c:IsAbleToRemoveAsCost()
end
function c27084913.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c27084913.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c27084913.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c27084913.rmfilter(c)
    return c:IsSetCard(0xc1c) and c:IsAbleToRemove()
end
function c27084913.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c27084913.rmfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c27084913.rmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c27084913.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end