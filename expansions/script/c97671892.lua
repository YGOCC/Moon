--Wyndbreaker Alfred
function c97671892.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,97671892)
    e1:SetCondition(c97671892.spcon)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,97672892)
    e2:SetCost(c97671892.spcost)
    e2:SetTarget(c97671892.sptg)
    e2:SetOperation(c97671892.spop)
    c:RegisterEffect(e2)
end
function c97671892.filter(c)
    return c:IsFaceup() and c:IsSetCard(0xd70)
end
function c97671892.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c97671892.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c97671892.cfilter(c,ft)
    return c:IsFaceup() and c:IsSetCard(0xd70) and c:IsAbleToHandAsCost() and (ft>0 or c:GetSequence()<5)
end
function c97671892.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c97671892.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),ft) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectMatchingCard(tp,c97671892.cfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),ft)
    Duel.SendtoHand(g,nil,REASON_COST)
end
function c97671892.spfilter(c,e,tp)
    return c:IsSetCard(0xd70) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c97671892.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c97671892.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c97671892.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c97671892.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end