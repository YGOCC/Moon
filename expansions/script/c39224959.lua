--Grimheart Elixir
--Design by Reverie
--Script by NightcoreJack
function c39224959.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,39224959+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c39224959.spcon)
    e1:SetTarget(c39224959.sptg)
    e1:SetOperation(c39224959.spop)
    c:RegisterEffect(e1)
end
function c39224959.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x37f)
end
function c39224959.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c39224959.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c39224959.spfilter(c,e,tp)
    return c:IsSetCard(0x37f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c39224959.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and Duel.IsExistingMatchingCard(c39224959.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c39224959.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectMatchingCard(tp,c39224959.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g1:GetCount()>0 then
        Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
        if not c:IsStatus(STATUS_ACT_FROM_HAND) and c:IsLocation(LOCATION_SZONE) and Duel.SelectYesNo(tp,aux.Stringid(39224959,0)) then
            Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g2=Duel.SelectMatchingCard(tp,c39224959.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g2:GetCount()>0 then
        Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
    end
    end
end
end