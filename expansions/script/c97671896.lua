--Wyndbreaker Arming
function c97671896.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,97671896+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c97671896.target)
    e1:SetOperation(c97671896.operation)
    c:RegisterEffect(e1)
end
function c97671896.thfilter(c,e)
    return c:IsType(TYPE_NORMAL) and c:IsSetCard(0xd70) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and c:IsCanBeEffectTarget(e)
end
function c97671896.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(c97671896.thfilter,tp,LOCATION_GRAVE,0,nil,e)
    if chk==0 then return g:GetClassCount(Card.GetCode)>=2 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=g:Select(tp,1,1,nil)
    g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g2=g:Select(tp,1,1,nil)
    g1:Merge(g2)
    Duel.SetTargetCard(g1)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,0,0)
end
function c97671896.operation(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    if sg:GetCount()>ft then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        sg=sg:Select(tp,ft,ft,nil)
    end
    Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end