--Dokurorider's Revival
--Script by TaxingCorn117
function c66823462.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,66823462+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c66823462.target)
    e1:SetOperation(c66823462.activate)
    c:RegisterEffect(e1)
end
--filters
function c66823462.mfilter(c)
    return c:GetLevel()>0 and (c:IsCode(99721536) or c:IsSetCard(0x1e0)) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c66823462.spfilter(c,e,tp,m)
    local newm=m:Clone()
    newm:RemoveCard(c)
    if (c:IsCode(99721536) or c:IsSetCard(0x1e0)) and bit.band(c:GetType(),0x81)==0x81 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and newm:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c) then
        newm:DeleteGroup()
        return true
    else
        newm:DeleteGroup()
        return false
    end
end
--Activate
function c66823462.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
        local mg=Duel.GetMatchingGroup(c66823462.mtfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,e:GetHandler(),e)
        return Duel.IsExistingMatchingCard(c66823462.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c66823462.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local mg0=Duel.GetMatchingGroup(c66823462.mtfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,2,e:GetHandler())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c66823462.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg0)
    local tc=g:GetFirst()
    if tc then
        local mg=mg0:Clone()
        mg:RemoveCard(tc)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
        tc:SetMaterial(mat)
        local mat2=mat:Clone()
        local hand_exc=mat:Filter(Card.IsLocation,nil,LOCATION_HAND)
        if hand_exc:GetCount()>0 then
            Duel.Remove(hand_exc,POS_FACEUP,REASON_MATERIAL+REASON_RITUAL)
            mat2:Sub(hand_exc)
        end
        Duel.ReleaseRitualMaterial(mat2)
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
