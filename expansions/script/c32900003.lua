--Explorer of the Fae
function c32900003.initial_effect(c)
    --send to grave
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(32900003,0))
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c32900003.target)
    e1:SetOperation(c32900003.operation)
    c:RegisterEffect(e1)
    --draw
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(32900003,2))
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c32900003.drtg)
    e2:SetOperation(c32900003.drop)
    c:RegisterEffect(e2)
    --search
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(32900003,3))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCondition(c32900003.thcon)
    e3:SetCost(aux.bfgcost)
    e3:SetTarget(c32900003.thtg)
    e3:SetOperation(c32900003.thop)
    c:RegisterEffect(e3)
    c32900003.banish_effect=e3
end
function c32900003.tgfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x13b) and c:IsAbleToGrave()
end
function c32900003.setfilter(c)
    return c:IsSetCard(0x13b) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c32900003.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32900003.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c32900003.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c32900003.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT) then
        local sg=Duel.GetMatchingGroup(c32900003.setfilter,tp,LOCATION_DECK,0,nil)
        if sg:GetCount()>0 and Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,32900001)>=3 and Duel.SelectYesNo(tp,aux.Stringid(32900003,1)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
            local sg=sg:Select(tp,1,1,nil)
            Duel.SSet(tp,sg)
            Duel.ConfirmCards(1-tp,sg)
        end
    end
end
function c32900003.tdfilter(c)
    return c:IsSetCard(0x13b) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c32900003.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c32900003.tdfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c32900003.tdfilter,tp,LOCATION_GRAVE,0,2,nil) and Duel.IsPlayerCanDraw(tp,1) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c32900003.tdfilter,tp,LOCATION_GRAVE,0,2,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c32900003.drop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=2 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    if ct==2 then
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
function c32900003.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()==e:GetHandler():GetTurnID()+1
end
function c32900003.thfilter(c)
    return c:IsSetCard(0x13b) and c:IsAbleToHand()
end
function c32900003.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c32900003.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c32900003.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c32900003.thfilter,tp,LOCATION_GRAVE,0,1,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c32900003.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    if sg:GetCount()>0 then
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
    end
end