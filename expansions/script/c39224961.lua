--Grimheart Destiny
--Design by Reverie
--Script by NightcoreJack
function c39224961.initial_effect(c)
    --recover
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCountLimit(1,39224961+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c39224961.target)
    e1:SetOperation(c39224961.operation)
    c:RegisterEffect(e1)
end
function c39224961.filter1(c)
    return c:IsFaceup() and c:IsSetCard(0x37f)
end
function c39224961.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local rec=Duel.GetMatchingGroupCount(c39224961.filter1,tp,LOCATION_MZONE,0,nil)*500
    if chk==0 then return rec>0 end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(rec)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c39224961.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rec=Duel.GetMatchingGroupCount(c39224961.filter1,tp,LOCATION_MZONE,0,nil)*500
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    Duel.Recover(p,rec,REASON_EFFECT)
    Duel.RDComplete()
    if not c:IsStatus(STATUS_ACT_FROM_HAND) and c:IsLocation(LOCATION_SZONE) and Duel.SelectYesNo(tp,aux.Stringid(39224961,0)) then
            Duel.BreakEffect()
    Duel.Damage(1-tp,1000,REASON_EFFECT)
end
end