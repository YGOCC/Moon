--Wyndbreaker Laura
function c97671887.initial_effect(c)
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,97671887)
    e1:SetTarget(c97671887.regtg)
    e1:SetOperation(c97671887.regop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_RELEASE)
    e3:SetCountLimit(1,97672887)
    e3:SetTarget(c97671887.sptg)
    e3:SetOperation(c97671887.spop)
    c:RegisterEffect(e3)
end
function c97671887.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_MONSTER) end
end
function c97671887.regop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetCondition(c97671887.thcon)
    e1:SetOperation(c97671887.thop)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c97671887.thfilter(c)
    return c:IsSetCard(0xd70) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c97671887.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c97671887.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function c97671887.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,97671887)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c97671887.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c97671887.spfilter(c,e,tp)
    return c:IsSetCard(0xd70) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c97671887.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c97671887.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c97671887.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c97671887.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end