--Hate
function c4672016.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c4672016.discon)
    e1:SetCost(c4672016.discost)
    e1:SetTarget(c4672016.distg)
    e1:SetOperation(c4672016.disop)
    c:RegisterEffect(e1)
end
function c4672016.discon(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsChainNegatable(ev) then return false end
    if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
    return re:IsHasCategory(CATEGORY_DISABLE)
end
function c4672016.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c4672016.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c4672016.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
end
