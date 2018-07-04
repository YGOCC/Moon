--Subzero Crystal - Alteration of the Crystals
function c88890013.initial_effect(c)
    --(1) Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(88890013,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c88890013.sptg)
    e1:SetOperation(c88890013.spop)
    c:RegisterEffect(e1)
    --(2) To hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(88890013,1))
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(aux.exccon)
    e2:SetTarget(c88890013.thtg)
    e2:SetOperation(c88890013.thop)
    c:RegisterEffect(e2)
end
--(1) Special summon
function c88890013.spmfilterf(c,tp,mg,rc)
    if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
        Duel.SetSelectedCard(c)
        return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
    else return false end
end
function c88890013.spfilter(c,e,tp,m1,m2,ft)
    if not c:IsSetCard(0x902) or bit.band(c:GetType(),0x81)~=0x81
    or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
    local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
    mg:Merge(m2)
    if (c:IsCode(88890001) or c:IsCode(88890005)) then return c:ritual_custom_condition(mg,ft) end
    if c.mat_filter then
    mg=mg:Filter(c.mat_filter,nil)
    end
    return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function c88890013.spmfilter(c)
    return c:GetLevel()>0 and c:IsSetCard(0x902) and bit.band(c:GetOriginalType(),0x81)==0x81 and c:IsAbleToDeck()
end
function c88890013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg1=Duel.GetRitualMaterial(tp)
        mg1:Remove(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
        local mg2=Duel.GetMatchingGroup(c88890013.spmfilter,tp,LOCATION_GRAVE+LOCATION_SZONE,0,nil)
        return Duel.IsExistingMatchingCard(c88890013.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1,mg2)
    end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c88890013.spop(e,tp,eg,ep,ev,re,r,rp)
    local mg1=Duel.GetRitualMaterial(tp)
    mg1:Remove(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
    local mg2=Duel.GetMatchingGroup(c88890013.spmfilter,tp,LOCATION_GRAVE+LOCATION_SZONE,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c88890013.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1,mg2)
    local tc=g:GetFirst()
    if tc then
        local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
        mg:Merge(mg2)
        if (tc:IsCode(88890001) or tc:IsCode(88890005)) then
            tc:ritual_custom_operation(mg)
            local mat=tc:GetMaterial()
            Duel.SendtoDeck(mat,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
        else
        if tc.mat_filter then
            mg=mg:Filter(tc.mat_filter,nil)
            end
            local mat=nil
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
            mat=mg:FilterSelect(tp,c88890013.spmfilterf,1,1,nil,tp,mg,tc)
            Duel.SetSelectedCard(mat)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
            local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
            mat:Merge(mat2)
            tc:SetMaterial(mat)
            local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_SZONE)
            mat:Sub(mat2)
            Duel.SendtoDeck(mat2,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
        end
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
--(2) To hand
function c88890013.thfilter(c)
    return c:IsSetCard(0x902) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c88890013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c88890013.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) 
    and e:GetHandler():IsAbleToDeck() end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c88890013.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c88890013.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end