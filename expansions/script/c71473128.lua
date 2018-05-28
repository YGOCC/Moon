--Fantasia Knight Reincarnation
function c71473128.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_ATTACK+TIMING_END_PHASE)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(71473128,0))
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_SZONE)
    e2:SetHintTiming(0,TIMING_END_PHASE)
    e2:SetCountLimit(1)
    e2:SetTarget(c71473128.drtg)
    e2:SetOperation(c71473128.drop)
    c:RegisterEffect(e2)
    --to extra
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(71473128,1))
    e3:SetCategory(CATEGORY_TOEXTRA)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,71473128)
    e3:SetCost(c71473128.tecost)
    e3:SetTarget(c71473128.tetg)
    e3:SetOperation(c71473128.teop)
    c:RegisterEffect(e3)
end
function c71473128.tdfilter(c)
    return c:IsSetCard(0x1c1d) and c:IsAbleToDeck()
end
function c71473128.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c71473128.tdfilter(chkc) end
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
        and Duel.IsExistingTarget(c71473128.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c71473128.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c71473128.drop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if tg:GetCount()<=0 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    Duel.ShuffleDeck(tp)
    Duel.BreakEffect()
    Duel.Draw(tp,1,REASON_EFFECT)
end
function c71473128.tecost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c71473128.tefilter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x1c1d) and not c:IsForbidden()
end
function c71473128.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetMatchingGroup(c71473128.tefilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
        return g:GetClassCount(Card.GetCode)>=2
    end
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,2,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c71473128.teop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c71473128.tefilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
    if g:GetClassCount(Card.GetCode)<2 then return end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71473128,1))
    local tg1=g:Select(tp,1,1,nil)
    g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71473128,1))
    local tg2=g:Select(tp,1,1,nil)
    tg1:Merge(tg2)
    if tg1:GetCount()==2 then
        Duel.SendtoExtraP(tg1,tp,REASON_EFFECT)
    end
end