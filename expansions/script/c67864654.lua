--Mekbuster Activation
function c67864654.initial_effect(c)
    --Search Lvl 6 or higher Light Machine
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(67864654,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67864654)
    e1:SetCondition(c67864654.thcon1)
    e1:SetTarget(c67864654.thtg1)
    e1:SetOperation(c67864654.thop1)
    c:RegisterEffect(e1)
    --Search "Mekbuster Engineer"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(67864654,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCountLimit(1,67864654)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCondition(c67864654.thcon2)
    e2:SetTarget(c67864654.thtg2)
    e2:SetOperation(c67864654.thop2)
    c:RegisterEffect(e2)
    --Special "Mekbuster Engineer"
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(67864654,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCountLimit(1,67864654)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCondition(c67864654.spcon)
    e3:SetTarget(c67864654.sptg)
    e3:SetOperation(c67864654.spop)
    c:RegisterEffect(e3)
end
function c67864654.cfilter1(c)
    return c:IsFaceup() and c:IsCode(67864641)
end
function c67864654.cfilter2(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE)
        and c:IsLevelAbove(6)
end
function c67864654.thcon1(e,c)
    if c==nil then return true end
    return Duel.IsExistingMatchingCard(c67864654.cfilter1,e:GetHandler(),LOCATION_ONFIELD,0,1,nil)
        and not Duel.IsExistingMatchingCard(c67864654.cfilter2,e:GetHandler(),LOCATION_ONFIELD,0,1,nil)
end
function c67864654.thfilter1(c)
    return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE)
        and c:IsLevelAbove(6) and c:IsAbleToHand()
end
function c67864654.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c67864654.thfilter1,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67864654.thop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c67864654.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c67864654.thcon2(e,c)
    if c==nil then return true end
    return Duel.IsExistingMatchingCard(c67864654.cfilter2,e:GetHandler(),LOCATION_ONFIELD,0,1,nil)
        and not Duel.IsExistingMatchingCard(c67864654.cfilter1,e:GetHandler(),LOCATION_ONFIELD,0,1,nil)
end
function c67864654.thfilter2(c)
    return c:IsCode(67864641) and c:IsAbleToHand()
end
function c67864654.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c67864654.thfilter2,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67864654.thop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c67864654.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c67864654.spcon(e,c)
    if c==nil then return true end
    return not Duel.IsExistingMatchingCard(c67864654.cfilter2,e:GetHandler(),LOCATION_ONFIELD,0,1,nil)
        and not Duel.IsExistingMatchingCard(c67864654.cfilter1,e:GetHandler(),LOCATION_ONFIELD,0,1,nil)
end
function c67864654.spfilter(c,e,tp)
    return c:IsCode(67864641) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67864654.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c67864654.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c67864654.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c67864654.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end