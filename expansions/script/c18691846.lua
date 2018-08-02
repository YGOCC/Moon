--KILLER BARRIER
function c18691846.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_BE_BATTLE_TARGET)
    e1:SetCountLimit(1)
    e1:SetCondition(c18691846.condition)
    e1:SetTarget(c18691846.target)
    e1:SetOperation(c18691846.activate)
    c:RegisterEffect(e1)
    --spsummon
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(18691846,0))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetCountLimit(1)
    e5:SetCost(aux.bfgcost)
    e5:SetTarget(c18691846.sptg)
    e5:SetOperation(c18691846.spop)
    c:RegisterEffect(e5)
end
function c18691846.condition(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return tc:IsControler(tp) and tc:IsFaceup() and tc:IsSetCard(0x50e)
end
function c18691846.filter(c)
    return c:IsAttackPos()
end
function c18691846.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c18691846.filter,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(c18691846.filter,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c18691846.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c18691846.filter,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsCanTurnSet() and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
        Duel.BreakEffect()
        c:CancelToGrave()
        Duel.ChangePosition(c,POS_FACEDOWN)
        Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
    end
end
function c18691846.spcon(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
        and Duel.GetDrawCount(tp)>0
end
function c18691846.spfilter(c,e,tp)
    return c:IsCode(18591813) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18691846.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c18691846.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c18691846.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
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
    local g=Duel.SelectTarget(tp,c18691846.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c18691846.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    _replace_count=_replace_count+1
    if _replace_count<=_replace_max and tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c18691846.spfilter(c,e,tp)
    return c:IsCode(18591813) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18691846.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c18691846.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c18691846.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c18691846.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c18691846.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end


