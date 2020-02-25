--"Cyberonia"
--by "Márcio Eduine"
local m=90007
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Link Materials"
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x20aa),2,2)
    --"To Hand"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90007,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,90007)
    e1:SetTarget(c90007.thtg)
    e1:SetOperation(c90007.thop)
    c:RegisterEffect(e1)
    --"ATK"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c90007.atkval)
    c:RegisterEffect(e2)
    --"Special Summon"
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCondition(c90007.spcon)
    e3:SetTarget(c90007.sptg)
    e3:SetOperation(c90007.spop)
    c:RegisterEffect(e3)
end
function c90007.thfilter1(c,tp)
    return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x20aa) and c:IsAbleToHand()
        and Duel.IsExistingMatchingCard(c90007.thfilter2,tp,LOCATION_DECK,0,1,c)
end
function c90007.thfilter2(c)
    return c:IsCode(90009) and c:IsAbleToHand()
end
function c90007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c90007.thfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c90007.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g1=Duel.SelectMatchingCard(tp,c90007.thfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
    if g1:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g2=Duel.SelectMatchingCard(tp,c90007.thfilter2,tp,LOCATION_DECK,0,1,1,g1:GetFirst())
        g1:Merge(g2)
        Duel.SendtoHand(g1,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g1)
    end
    Duel.RegisterFlagEffect(tp,90007,RESET_PHASE+PHASE_END,0,1)
end
function c90007.atkfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x20aa) and c:IsType(TYPE_PENDULUM)
end
function c90007.atkval(e,c)
    local g=Duel.GetMatchingGroup(c90007.atkfilter,c:GetControler(),LOCATION_EXTRA,0,nil)
    return g:GetClassCount(Card.GetCode)*200
end
function c90007.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_BATTLE)
        or (rp==1-tp and c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==tp)
end
function c90007.spfilter(c,e,tp)
    return c:IsSetCard(0x20aa) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c90007.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c90007.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c90007.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end