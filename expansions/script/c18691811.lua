--SUPER QUICK - XYZ
function c18691811.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c18691811.target)
    e1:SetOperation(c18691811.activate)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(18691811,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_IGNITION)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCondition(c18691811.spcon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c18691811.sptg)
    e2:SetOperation(c18691811.spop)
    c:RegisterEffect(e2)
end
function c18691811.filter(c)
    return c:IsSpecialSummonable(SUMMON_TYPE_XYZ)
end
function c18691811.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c18691811.filter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c18691811.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c18691811.filter,tp,LOCATION_EXTRA,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_XYZ)
    end
end
function c18691811.spcon(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
        and Duel.GetDrawCount(tp)>0
end
function c18691811.spfilter(c,e,tp)
    return c:IsType(TYPE_XYZ) and c:IsSetCard(0x50e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18691811.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c18691811.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c18691811.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
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
    local g=Duel.SelectTarget(tp,c18691811.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c18691811.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    _replace_count=_replace_count+1
    if _replace_count<=_replace_max and tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
