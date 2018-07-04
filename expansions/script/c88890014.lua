--Subzero Crystal - Jar of Awakened Crystals
function c88890014.initial_effect(c)
    --(1) Draw
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(88890014,0))
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,88890014+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(c88890014.drcost)
    e1:SetTarget(c88890014.drtg)
    e1:SetOperation(c88890014.drop)
    c:RegisterEffect(e1)
end
--(1) Draw
function c88890014.drcostfilter(c,tp)
    return c:IsSetCard(0x902) and c:IsType(TYPE_RITUAL) and c:IsAbleToRemoveAsCost()
end
function c88890014.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c88890014.drcostfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c88890014.drcostfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    local tg=g:GetFirst()
    --(1.1) Shuffle
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetRange(LOCATION_REMOVED)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetCountLimit(1)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
    e1:SetCondition(c88890014.tdcon)
    e1:SetOperation(c88890014.tdop)
    e1:SetLabel(0)
    tg:RegisterEffect(e1)
end
function c88890014.drfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x902)
end
function c88890014.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=Duel.GetMatchingGroupCount(c88890014.drfilter,tp,LOCATION_MZONE,0,nil)
    if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c88890014.drop(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local d=Duel.GetMatchingGroupCount(c88890014.drfilter,tp,LOCATION_MZONE,0,nil)
    Duel.Draw(p,d,REASON_EFFECT)
end
--(1.1) Shuffle
function c88890014.tdcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c88890014.tdop(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetLabel()
    e:GetHandler():SetTurnCounter(ct+1)
    if ct==1 then
        Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
    else e:SetLabel(1) end
end
