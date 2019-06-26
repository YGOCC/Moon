--created by ZEN, coded by TaxingCorn117
--Blood Arts - Bat Storm
local function getID()
    local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
    str=string.sub(str,1,string.len(str)-4)
    local cod=_G[str]
    local id=tonumber(string.sub(str,2))
    return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
    e1:SetCondition(cid.rmcon)
    e1:SetCost(cid.rmcost)
    e1:SetTarget(cid.rmtg)
    e1:SetOperation(cid.rmop)
    c:RegisterEffect(e1)
end
function cid.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x52f)
end
function cid.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_MZONE,0,1,nil) or Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_REMOVED,0,1,nil)
end
function cid.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cid.rmfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cid.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and cid.rmfilter(chkc) and chkc~=e:GetHandler() end
    if chk==0 then return Duel.IsExistingTarget(cid.rmfilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,cid.rmfilter,tp,0,LOCATION_ONFIELD,1,2,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cid.ctfilter2(c)
    return c:IsLocation(LOCATION_REMOVED) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cid.rmop(e,tp,eg,ep,ev,re,r,rp)
    local ct1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if ct1>0 then
        if Duel.Remove(tp,POS_FACEUP,REASON_EFFECT)~=0 then
            local og=Duel.GetOperatedGroup()
            local ct2=og:FilterCount(cid.ctfilter2,nil)
            if ct2>0 then
                Duel.Damage(tp,ct2*200,REASON_EFFECT)
            end
        end
    end
end