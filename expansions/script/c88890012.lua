--Subzero Crystal - Arrival of the Crystal Gods
function c88890012.initial_effect(c)
    --(1) Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(88890012,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1)
    e1:SetCondition(c88890012.spcon)
    e1:SetTarget(c88890012.sptg)
    e1:SetOperation(c88890012.spop)
    c:RegisterEffect(e1)
    --(2) Shuffle
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(88890012,1))
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCondition(aux.exccon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c88890012.tdtg)
    e2:SetOperation(c88890012.tdop)
    c:RegisterEffect(e2)
    --(3) Ritual Summon count
    if not c88890012.global_check then
        c88890012.global_check=true
        c88890012[0]=0
        c88890012[1]=0
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e3:SetCode(EVENT_SPSUMMON_SUCCESS)
        e3:SetOperation(c88890012.checkop)
        Duel.RegisterEffect(e3,0)
    end
end
--(1) Special summon
function c88890012.spcon(e,tp,eg,ep,ev,re,r,rp)
    return c88890012[tp]>4
end
function c88890012.spmfilterf(c,tp,mg,rc)
  if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
    Duel.SetSelectedCard(c)
    return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
  else return false end
end
function c88890012.spfilter(c,e,tp,m1,m2,ft)
    if not c:IsSetCard(0x902) or bit.band(c:GetType(),0x81)~=0x81 or c:GetLevel()~=12
    or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
    local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
    mg:Merge(m2)
    if (c:IsCode(88890001) or c:IsCode(88890005)) then return c:ritual_custom_condition(mg,ft) end
    if c.mat_filter then
    mg=mg:Filter(c.mat_filter,nil)
    end
    return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function c88890012.spmfilter(c)
   return c:GetLevel()==6 and c:IsSetCard(0x902) and bit.band(c:GetOriginalType(),0x81)==0x81 and c:IsAbleToRemove()
end
function c88890012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg1=Duel.GetRitualMaterial(tp)
        mg1:Remove(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
        local mg2=Duel.GetMatchingGroup(c88890012.spmfilter,tp,LOCATION_GRAVE+LOCATION_SZONE,0,nil)
        return Duel.IsExistingMatchingCard(c88890012.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1,mg2)
    end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
    if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
        Duel.SetChainLimit(c88890012.chlimit)
    end
end
function c88890012.chlimit(e,ep,tp)
    return tp==ep
end
function c88890012.spop(e,tp,eg,ep,ev,re,r,rp)
    local mg1=Duel.GetRitualMaterial(tp)
    mg1:Remove(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
    local mg2=Duel.GetMatchingGroup(c88890012.spmfilter,tp,LOCATION_GRAVE+LOCATION_SZONE,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c88890012.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1,mg2)
    local tc=g:GetFirst()
    if tc then
        local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
        mg:Merge(mg2)
        if (tc:IsCode(88890001) or tc:IsCode(88890005)) then
            tc:ritual_custom_operation(mg)
            local mat=tc:GetMaterial()
            Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
        else
            if tc.mat_filter then
                mg=mg:Filter(tc.mat_filter,nil)
            end
            local mat=nil
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
            mat=mg:FilterSelect(tp,c88890012.spmfilterf,1,1,nil,tp,mg,tc)
            Duel.SetSelectedCard(mat)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
            local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
            mat:Merge(mat2)
            tc:SetMaterial(mat)
            local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_SZONE)
            mat:Sub(mat2)
            Duel.Remove(mat2,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
        end
        Duel.BreakEffect()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(tc:GetMaterialCount()*100)
        e1:SetReset(RESET_EVENT+0xfe0000)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        tc:RegisterEffect(e2)
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
--(2) Shuffle
function c88890012.tdfilter(c)
    return c:IsSetCard(0x902) and bit.band(c:GetOriginalType(),0x81)==0x81 and c:IsAbleToDeck()
end
function c88890012.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c88890012.tdfilter,tp,LOCATION_REMOVED,0,1,nil) 
    and Duel.IsPlayerCanDraw(tp,1) end
    local g=Duel.GetMatchingGroup(c88890012.tdfilter,tp,LOCATION_REMOVED,0,nil)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c88890012.tdop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c88890012.tdfilter,tp,LOCATION_REMOVED,0,nil)
    if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
        Duel.ShuffleDeck(tp)
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
--(3) Ritual Summon count
function c88890012.checkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    while tc do
        if tc:IsSetCard(0x902) and tc:GetLevel()==6 and bit.band(tc:GetType(),0x81)==0x81
        and bit.band(tc:GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL then
        local p=tc:GetSummonPlayer()
        c88890012[p]=c88890012[p]+1
        end
        tc=eg:GetNext()
    end
end