--Celestian Twin Burst
function c37888500.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,37888500+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c37888500.target)
    e1:SetOperation(c37888500.activate)
    c:RegisterEffect(e1)
end
function c37888500.ddfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xebb)
end
function c37888500.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c37888500.ddfilter(chkc) end
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
        and Duel.IsExistingTarget(c37888500.ddfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c37888500.ddfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c37888500.activate(e,tp,eg,ep,ev,re,r,rp)
    local g,p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    g=g:Filter(Card.IsRelateToEffect,nil,e)
    if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
        Duel.Draw(p,d,REASON_EFFECT)
    end
end