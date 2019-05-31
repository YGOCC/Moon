--Fae Sanctuary
function c32900008.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,32900008+EFFECT_COUNT_CODE_OATH)
    e1:SetOperation(c32900008.activate)
    c:RegisterEffect(e1)
    --destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c32900008.reptg)
    e2:SetValue(c32900008.repval)
    c:RegisterEffect(e2)
    --to deck
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e3:SetCondition(c32900008.tdcon)
    e3:SetTarget(c32900008.tdtg)
    e3:SetOperation(c32900008.tdop)
    c:RegisterEffect(e3)
end
function c32900008.filter(c)
    return c:IsSetCard(0x13b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c32900008.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c32900008.filter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(32900008,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function c32900008.repfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
        and c:IsRace(RACE_FAIRY) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c32900008.tgfilter(c)
    return c:IsRace(RACE_FAIRY) and c:IsAbleToGrave()
end
function c32900008.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c32900008.repfilter,1,nil,tp)
        and Duel.IsExistingMatchingCard(c32900008.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local sg=Duel.SelectMatchingCard(tp,c32900008.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
        Duel.Hint(HINT_CARD,0,32900008)
        Duel.SendtoGrave(sg,REASON_EFFECT)
        return true
    else return false end
end
function c32900008.repval(e,c)
    return c32900008.repfilter(c,e:GetHandlerPlayer())
end
function c32900008.tdcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_FZONE)
end
function c32900008.tdfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x13b)
end
function c32900008.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c32900008.tdfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c32900008.tdfilter,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c32900008.tdfilter,tp,LOCATION_REMOVED,0,1,3,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c32900008.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
    if sg:GetCount()>0 then
        Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
    end
end