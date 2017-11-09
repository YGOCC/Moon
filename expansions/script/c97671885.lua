--Wyndbreaker Jamie
function c97671885.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(97671885,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,97671885)
    e1:SetTarget(c97671885.sptg)
    e1:SetOperation(c97671885.spop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_RELEASE)
    e3:SetCountLimit(1,97672885)
    e3:SetTarget(c97671885.rmtg)
    e3:SetOperation(c97671885.rmop)
    c:RegisterEffect(e3)
end
function c97671885.filter(c,e,tp)
    return c:IsSetCard(0xd70) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c97671885.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c97671885.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c97671885.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c97671885.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c97671885.thfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd70) and c:IsAbleToHand()
end
function c97671885.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()==tp and c97671885.thfilter(chkc) end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c97671885.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c97671885.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end
end