--Wyndbreaker Calling
function c97671895.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,97671895+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c97671895.target)
    e1:SetOperation(c97671895.activate)
    c:RegisterEffect(e1)
end
function c97671895.thfilter(c)
    return c:IsSetCard(0xd70) and c:IsType(TYPE_NORMAL) and c:IsAbleToHand()
end
function c97671895.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetMatchingGroup(c97671895.thfilter,tp,LOCATION_DECK,0,nil)
        return g:GetClassCount(Card.GetCode)>=2
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c97671895.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c97671895.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetClassCount(Card.GetCode)>=2 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g1=g:Select(tp,1,1,nil)
        g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g2=g:Select(tp,1,1,nil)
        g1:Merge(g2)
        Duel.SendtoHand(g1,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g1)
    end
end

