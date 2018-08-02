--ASSASSIN - JULIANNE
function c18591847.initial_effect(c)
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(18591847,0))
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetCondition(aux.dogcon)
    e1:SetTarget(c18591847.target)
    e1:SetOperation(c18591847.operation)
    c:RegisterEffect(e1)
end
function c18591847.dfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c18591847.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c18591847.dfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c18591847.dfilter,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c18591847.dfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c18591847.spfilter(c,e,tp)
    return c:IsCode(18591846) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18591847.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
        local g=Duel.GetMatchingGroup(c18591847.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
        if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(18591847,1)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sg=g:Select(tp,1,1,nil)
            Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end

