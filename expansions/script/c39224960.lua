--Grimheart Contract
--Design by Reverie
--Script by NightcoreJack
function c39224960.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,39224960+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c39224960.condition)
    e1:SetCost(c39224960.cost)
    e1:SetTarget(c39224960.target)
    e1:SetOperation(c39224960.activate)
    c:RegisterEffect(e1)
end
function c39224960.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x37f)
end
function c39224960.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c39224960.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c39224960.filter(c)
    return c:IsSetCard(0x37f) and c:IsDiscardable()
end
function c39224960.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c39224960.filter,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,c39224960.filter,1,1,REASON_COST+REASON_DISCARD)
end
function c39224960.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    if not c:IsStatus(STATUS_ACT_FROM_HAND) and c:IsLocation(LOCATION_SZONE) then
        e:SetLabel(1)
    else
        e:SetLabel(0)
    end
end
function c39224960.activate(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    if Duel.Draw(p,1,REASON_EFFECT)>0 and e:GetLabel()==1 and Duel.IsPlayerCanDraw(p,2)
        and Duel.SelectYesNo(p,aux.Stringid(39224960,1)) then
        Duel.BreakEffect()
        Duel.Draw(p,2,REASON_EFFECT)
    end
end