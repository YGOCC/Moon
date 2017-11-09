--Wyndbreaker Twin Strike
function c97671894.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,97671894)
    e1:SetCost(c97671894.cost)
    e1:SetTarget(c97671894.target)
    e1:SetOperation(c97671894.activate)
    c:RegisterEffect(e1)
end
function c97671894.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroupEx(tp,Card.IsSetCard,1,e:GetHandler(),0xd70) end
    local g=Duel.SelectReleaseGroupEx(tp,Card.IsSetCard,1,1,e:GetHandler(),0xd70)
    Duel.Release(g,REASON_COST)
end
function c97671894.filter(c,e,tp)
    return c:IsType(TYPE_NORMAL) and c:IsSetCard(0xd70) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c97671894.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c97671894.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND)
end
function c97671894.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c97671894.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end