--Exostorm Flight Storm
function c27084919.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,27084919)
    e1:SetCost(c27084919.cost)
    e1:SetTarget(c27084919.target)
    e1:SetOperation(c27084919.activate)
    c:RegisterEffect(e1)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(27084919,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,27084919)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c27084919.thtg)
    e2:SetOperation(c27084919.thop)
    c:RegisterEffect(e2)
end
function c27084919.filter(c)
    return c:IsSetCard(0xc1c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c27084919.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c27084919.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c27084919.filter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c27084919.thfilter1(c)
    return c:IsSetCard(0xc1c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c27084919.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c27084919.thfilter1,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c27084919.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c27084919.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c27084919.thfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xc1c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c27084919.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c27084919.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c27084919.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c27084919.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27084919.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end