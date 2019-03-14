--"Cyberonius"
--by "Márcio Eduine"
local m=90008
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Link Materials"
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x20aa),2)
    c:EnableReviveLimit()
    --"Search"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90008,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,90008)
    e1:SetCondition(c90008.con)
    e1:SetTarget(c90008.target)
    e1:SetOperation(c90008.operation)
    c:RegisterEffect(e1)
    --"ATK"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c90008.atkval)
    c:RegisterEffect(e2)
    --"Special Summon"
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(90008,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCondition(c90008.spcon)
    e3:SetTarget(c90008.sptg)
    e3:SetOperation(c90008.spop)
    c:RegisterEffect(e3)
end
function c90008.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c90008.filter(c)
    return c:IsSetCard(0x20aa) and c:IsAbleToHand()
end
function c90008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c90008.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c90008.operation(e,tp,eg,ep,ev,re,r,rp,chk)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c90008.filter,tp,LOCATION_DECK,0,1,2,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c90008.atkfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x20aa) and c:IsType(TYPE_PENDULUM)
end
function c90008.atkval(e,c)
    local g=Duel.GetMatchingGroup(c90008.atkfilter,c:GetControler(),LOCATION_EXTRA,0,nil)
    return g:GetClassCount(Card.GetCode)*300
end
function c90008.spcon(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and e:GetHandler():GetPreviousControler()==tp
end
function c90008.spfilter(c,e,tp)
    return c:IsCode(90007,90010) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90008.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c90008.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c90008.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c90008.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c90008.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end