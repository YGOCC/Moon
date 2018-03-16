--EX-Exostorm Atomic Cannon
function c27084917.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xc1c),6,2)
    c:EnableReviveLimit()
    --remove
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(27084917,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c27084917.rmcon)
    e1:SetTarget(c27084917.rmtg)
    e1:SetOperation(c27084917.rmop)
    c:RegisterEffect(e1)
    --specialsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(27084917,1))
    e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCost(c27084917.rmcost1)
    e3:SetTarget(c27084917.rmtg1)
    e3:SetOperation(c27084917.rmop1)
    c:RegisterEffect(e3)
end
function c27084917.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c27084917.rmfilter(c)
    return c:IsSetCard(0xc1c) and c:IsAbleToRemove()
end
function c27084917.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c27084917.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
    local g=Duel.GetMatchingGroup(c27084917.rmfilter,tp,LOCATION_GRAVE,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c27084917.rmop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c27084917.rmfilter,tp,LOCATION_GRAVE,0,nil)
    if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end
function c27084917.rmfil(c)
    return c:IsSetCard(0xc1c) and c:IsAbleToRemoveAsCost()
end
function c27084917.rmcost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(c27084917.rmfil,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():GetAttackAnnouncedCount()==0 end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c27084917.rmfil,tp,LOCATION_DECK,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c27084917.spfilter(c,e,tp)
    return c:IsSetCard(0xc1c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function c27084917.rmtg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c27084917.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c27084917.rmop1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c27084917.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
    end
end