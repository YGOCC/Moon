--"Tracking King and Queen"
local m=18591836
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Search"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(18591836,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetTarget(c18591836.thtg)
    e1:SetOperation(c18591836.thop)
    c:RegisterEffect(e1)
end
function c18591836.thfilter1(c,tp)
    return c:IsCode(18591823) and c:IsAbleToHand()
        and Duel.IsExistingMatchingCard(c18591836.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c)
end
function c18591836.thfilter2(c)
    return c:IsCode(18591821) and c:IsAbleToHand()
end
function c18591836.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c18591836.thfilter1,tp,LOCATION_DECKLOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECKLOCATION_DECK+LOCATION_GRAVE)
end
function c18591836.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g1=Duel.SelectMatchingCard(tp,c18591836.thfilter1,tp,LOCATION_DECKLOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
    if g1:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g2=Duel.SelectMatchingCard(tp,c18591836.thfilter2,tp,LOCATION_DECKLOCATION_DECK+LOCATION_GRAVE,0,1,1,g1:GetFirst())
        g1:Merge(g2)
        Duel.SendtoHand(g1,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g1)
    end
end