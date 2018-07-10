--Wild Mini Ninjas
function c18591850.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --extra summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,LOCATION_HAND+LOCATION_MZONE)
    e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WARRIOR))
    e2:SetOperation(c18591850.esop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetCondition(c18591850.ctcon)
    e3:SetOperation(c18591850.ctop)
    c:RegisterEffect(e3)
    
end
function c18591850.esop(e,tp,eg,ep,ev,re,r,rp,c)
    c:RegisterFlagEffect(18591850,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
end
function c18591850.ctcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:GetFirst():GetFlagEffect(18591850)~=0
end
function c18591850.lrcon(e,tp,eg,ep,ev,re,r,rp)
    if tp~=ep then return false end
    local lp=Duel.GetLP(ep)
    if lp<ev then return false end
    if not re or not re:IsHasType(0x7e0) then return false end
    local rc=re:GetHandler()
    return rc:IsLocation(LOCATION_MZONE) and rc:IsRace(RACE_WARRIOR)
end