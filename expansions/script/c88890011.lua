--Subzero Crystal - Awakening of the Crystal Guardians
function c88890011.initial_effect(c)
    --(1) Special Summon 1
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(88890011,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c88890011.sptg1)
    e1:SetOperation(c88890011.spop1)
    c:RegisterEffect(e1)
    --(2) Special Summon 2
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(88890011,1))
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(aux.exccon)
    e2:SetTarget(c88890011.sptg2)
    e2:SetOperation(c88890011.spop2)
    c:RegisterEffect(e2)
end
--(1) Special Summon 1
function c88890011.spmfilterf(c,tp,mg,rc)
  if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
    Duel.SetSelectedCard(c)
    return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
  else return false end
end
function c88890011.spfilter1(c,e,tp,m,ft)
    if not c:IsSetCard(0x902) or bit.band(c:GetType(),0x81)~=0x81 or c:GetLevel()~=6
    or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
    local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
    if c.mat_filter then
    mg=mg:Filter(c.mat_filter,nil)
    end
    if c.mat_filter then
        mg=mg:Filter(c.mat_filter,nil)
    end
    if ft>0 then
        return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
    else
        return mg:IsExists(c88890011.spmfilterf,1,nil,tp,mg,c)
    end
end
function c88890011.spmfilter1(c)
    return c:GetLevel()>0 and c:IsAbleToGrave()
end
function c88890011.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetRitualMaterial(tp)
        local sg=Duel.GetMatchingGroup(c88890011.spmfilter1,tp,LOCATION_DECK,0,nil)
        mg:Merge(sg)
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        return ft>-1 and Duel.IsExistingMatchingCard(c88890011.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp,mg,ft)
    end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c88890011.spop1(e,tp,eg,ep,ev,re,r,rp)
    local mg=Duel.GetRitualMaterial(tp)
    local sg=Duel.GetMatchingGroup(c88890011.spmfilter1,tp,LOCATION_DECK,0,nil)
    mg:Merge(sg)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,c88890011.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg,ft)
    local tc=tg:GetFirst()
    if tc then
        mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
        if tc.mat_filter then
        mg=mg:Filter(tc.mat_filter,nil)
        end
        local mat=nil
        if ft>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
        else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        mat=mg:FilterSelect(tp,c88890011.spmfilterf,1,1,nil,tp,mg,tc)
        Duel.SetSelectedCard(mat)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
        mat:Merge(mat2)
        end
        tc:SetMaterial(mat)
        local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
        mat:Sub(mat2)
        Duel.ReleaseRitualMaterial(mat)
        Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
--(2) Special Summon 2
function c88890011.filter2(c,e,tp,m1,m2)
    if not c:IsSetCard(0x902) or bit.band(c:GetType(),0x81)~=0x81
    or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
    mg:Merge(m2)
    if (c:IsCode(88890001) or c:IsCode(88890005)) then return c:ritual_custom_condition(mg,ft) end
    if c.mat_filter then
        mg=mg:Filter(c.mat_filter,nil)
    end
    return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function c88890011.mfilter2(c)
    return c:GetLevel()>0 and c:IsAbleToRemove() 
end
function c88890011.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg1=Duel.GetRitualMaterial(tp)
        mg1:Remove(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
        local mg2=Duel.GetMatchingGroup(c88890011.mfilter2,tp,0,LOCATION_GRAVE,nil)
        return Duel.IsExistingMatchingCard(c88890011.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg1,mg2) 
        and e:GetHandler():IsAbleToDeck()
    end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c88890011.spop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
        local mg1=Duel.GetRitualMaterial(tp)
        mg1:Remove(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
        local mg2=Duel.GetMatchingGroup(c88890011.mfilter2,tp,0,LOCATION_GRAVE,nil)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c88890011.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg1,mg2)
        local tc=g:GetFirst()
        if tc then
            local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
            mg:Merge(mg2)
            local mat=nil   
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
            mat=mg:FilterSelect(tp,c88890011.spmfilterf,1,1,nil,tp,mg,tc)
            Duel.SetSelectedCard(mat)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
            local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
            mat:Merge(mat2)
            tc:SetMaterial(mat)
            local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
            mat:Sub(mat2)
            Duel.Remove(mat2,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
            Duel.BreakEffect()
            Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
            tc:CompleteProcedure()
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1,true)
            local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e2,true)
            local e3=Effect.CreateEffect(e:GetHandler())
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_CANNOT_ATTACK)
            e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e3,true)
        end
    end
end