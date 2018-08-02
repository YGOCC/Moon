--REWARD FOR A ASSASSIN
function c18591843.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --boost
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetValue(c18591843.atkval)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)
    --spsummon
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(18591843,0))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetCost(aux.bfgcost)
    e5:SetTarget(c18591843.sptg)
    e5:SetOperation(c18591843.spop)
    c:RegisterEffect(e5)
end
function c18591843.atkval(e,c)
    return Duel.GetMatchingGroup(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil,TYPE_MONSTER):GetClassCount(Card.GetRace)*200
end
function c18591843.spcon(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
        and Duel.GetDrawCount(tp)>0
end
function c18591843.spfilter(c,e,tp)
    return c:IsSetCard(0x50e) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18591843.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c18591843.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c18591843.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    local dt=Duel.GetDrawCount(tp)
    if dt~=0 then
        _replace_count=0
        _replace_max=dt
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCode(EFFECT_DRAW_COUNT)
        e1:SetTargetRange(1,0)
        e1:SetReset(RESET_PHASE)
        e1:SetValue(0)
        Duel.RegisterEffect(e1,tp)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c18591843.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c18591843.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    _replace_count=_replace_count+1
    if _replace_count<=_replace_max and tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c18591843.spfilter(c,e,tp)
    return c:IsSetCard(0x50e) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18591843.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c18591843.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c18591843.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c18591843.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c18591843.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
