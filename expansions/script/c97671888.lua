--Wyndbreaker Lily
function c97671888.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(97671888,1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,97671888)
    e1:SetTarget(c97671888.target)
    e1:SetOperation(c97671888.operation)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_RELEASE)
    e3:SetCountLimit(1,97672888)
    e3:SetTarget(c97671888.target1)
    e3:SetOperation(c97671888.operation1)
    c:RegisterEffect(e3)
end
function c97671888.filter(c,e,tp)
    return c:IsSetCard(0xd70) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c97671888.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c97671888.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c97671888.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c97671888.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c97671888.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c97671888.filter1(c)
    return c:IsSetCard(0xd70) and c:IsAbleToDeck()
end
function c97671888.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c97671888.filter1(chkc) end
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c97671888.filter1,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c97671888.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c97671888.operation1(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=1 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    if ct==1 then
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end