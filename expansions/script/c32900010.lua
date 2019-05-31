--Fae Calling
function c32900010.initial_effect(c)
    --to hand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(32900010,1))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,32900010)
    e1:SetCost(c32900010.thcost)
    e1:SetTarget(c32900010.thtg)
    e1:SetOperation(c32900010.thop)
    c:RegisterEffect(e1)
    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c32900010.drtg)
    e2:SetOperation(c32900010.drop)
    c:RegisterEffect(e2)
end
function c32900010.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c32900010.thfilter(c)
    return c:IsSetCard(0x13b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c32900010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local dg=Duel.GetMatchingGroup(c32900010.thfilter,tp,LOCATION_DECK,0,nil)
        return dg:GetClassCount(Card.GetCode)>=3
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    if Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,32900001)>=3 then
        e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES+CATEGORY_DRAW)
    end
end
function c32900010.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c32900010.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetClassCount(Card.GetCode)>=3 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local sg1=g:Select(tp,1,1,nil)
        g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local sg2=g:Select(tp,1,1,nil)
        g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local sg3=g:Select(tp,1,1,nil)
        sg1:Merge(sg2)
        sg1:Merge(sg3)
        Duel.ConfirmCards(1-tp,sg1)
        Duel.ShuffleDeck(tp)
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
        local cg=sg1:Select(1-tp,1,1,nil)
        local tc=cg:GetFirst()
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        sg1:RemoveCard(tc)
        Duel.SendtoGrave(sg1,REASON_EFFECT)
        if Duel.IsPlayerCanDraw(tp,1)
            and Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,32900001)>=3
            and Duel.SelectYesNo(tp,aux.Stringid(63166095,0)) then
            Duel.BreakEffect()
            Duel.ShuffleDeck(tp)
            Duel.Draw(tp,1,REASON_EFFECT)
        end
    end
end
function c32900010.tdfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) 
        and c:IsSetCard(0x13b) and c:IsAbleToDeck()
end
function c32900010.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c32900010.tdfilter(chkc) end
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
        and Duel.IsExistingTarget(c32900010.tdfilter,tp,LOCATION_REMOVED,0,3,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c32900010.tdfilter,tp,LOCATION_REMOVED,0,3,3,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c32900010.drop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if tg:GetCount()<=0 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    if ct>0 then
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end