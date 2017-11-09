--Wyndbreaker Isabella
function c97671891.initial_effect(c)
--destroy
local e1=Effect.CreateEffect(c)
e1:SetCategory(CATEGORY_DESTROY)
e1:SetType(EFFECT_TYPE_IGNITION)
e1:SetRange(LOCATION_MZONE)
e1:SetCountLimit(1)
e1:SetCost(c97671891.descost)
e1:SetTarget(c97671891.destg)
e1:SetOperation(c97671891.desop)
c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
e2:SetCode(EVENT_RELEASE)
e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
e2:SetCountLimit(1,97671891)
e2:SetTarget(c97671891.sptg)
e2:SetOperation(c97671891.spop)
c:RegisterEffect(e2)
end
function c97671891.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,e:GetHandler(),0xd70) end
    local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,e:GetHandler(),0xd70)
    Duel.Release(g,REASON_COST)
end
function c97671891.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c97671891.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function c97671891.spfilter(c,e,tp)
    return c:IsCode(97671891) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c97671891.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c97671891.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c97671891.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    if ft>=2 then ft=2 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c97671891.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,ft,nil,e,tp)
    if g:GetCount()>0 then
        local t1=g:GetFirst()
        local t2=g:GetNext()
        Duel.SpecialSummonStep(t1,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_TRIGGER)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        t1:RegisterEffect(e1)
        if t2 then
            Duel.SpecialSummonStep(t2,0,tp,tp,false,false,POS_FACEUP)
            local e2=e1:Clone()
            t2:RegisterEffect(e2)
        end
        Duel.SpecialSummonComplete()
    end
end
