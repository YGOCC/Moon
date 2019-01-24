--"Cheater Computer"
local m=90082
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Only One"
    c:SetUniqueOnField(1,0,90082)
    --"Activate"
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --"Trap activate in set turn"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e1:SetRange(LOCATION_SZONE)
    e1:SetTargetRange(LOCATION_SZONE,0)
    e1:SetCountLimit(1)
    c:RegisterEffect(e1)
    --"Send to GY"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90082,0))
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_SZONE)
    e2:SetHintTiming(0,TIMING_END_PHASE)
    e2:SetCountLimit(1)
    e2:SetCondition(c90082.condition0)
    e2:SetTarget(c90082.target1)
    e2:SetOperation(c90082.activate)
    c:RegisterEffect(e2)
    --"Instant"
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(90082,1))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,TIMING_END_PHASE)
    e3:SetLabel(1)
    e3:SetCondition(c90082.condition1)
    e3:SetTarget(c90082.target2)
    e3:SetOperation(c90082.activate)
    c:RegisterEffect(e3)
    --"Special Summmon"
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(90082,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCondition(c90082.spcon)
    e4:SetTarget(c90082.sptg)
    e4:SetOperation(c90082.spop)
    c:RegisterEffect(e4)
    --"Damage"
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(90082,1))
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_REMOVE)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetCondition(c90082.damcon)
    e5:SetOperation(c90082.damop)
    c:RegisterEffect(e5)
end
function c90082.filter1(c)
    return (c:IsSetCard(0x1aa) or c:IsSetCard(0x1dd)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c90082.filter2(c)
    return c:IsFaceup() and (c:IsSetCard(0x1aa) or c:IsSetCard(0x1dd)) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c90082.condition0(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function c90082.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    e:SetLabel(0)
    local turnp=Duel.GetTurnPlayer()
    if ((turnp~=tp and Duel.IsExistingMatchingCard(c90082.filter1,tp,LOCATION_DECK,0,1,nil))
        or (turnp==tp and Duel.IsExistingMatchingCard(c90082.filter2,tp,LOCATION_REMOVED,0,1,nil)))
        and Duel.SelectYesNo(tp,aux.Stringid(90082,0)) then
        if turnp==tp then
            Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
        else
            Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
        end
        e:SetLabel(1)
        e:GetHandler():RegisterFlagEffect(90082,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
    end
end
function c90082.condition1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c90082.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    local turnp=Duel.GetTurnPlayer()
    if chk==0 then return e:GetHandler():GetFlagEffect(90082)==0
        and ((turnp~=tp and Duel.IsExistingMatchingCard(c90082.filter1,tp,LOCATION_DECK,0,1,nil))
        or (turnp==tp and Duel.IsExistingMatchingCard(c90082.filter2,tp,LOCATION_REMOVED,0,1,nil))) end
    if turnp==tp then
        Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
    else
        Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
    end
    e:GetHandler():RegisterFlagEffect(90082,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c90082.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if e:GetLabel()~=1 or not c:IsRelateToEffect(e) then return end
    local turnp=Duel.GetTurnPlayer()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    if turnp~=tp then
        local g=Duel.SelectMatchingCard(tp,c90082.filter1,tp,LOCATION_DECK,0,1,1,nil)
        Duel.SendtoGrave(g,REASON_EFFECT)
    else
        local g=Duel.SelectMatchingCard(tp,c90082.filter2,tp,LOCATION_REMOVED,0,1,1,nil)
        Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
    end
end
function c90082.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c90082.filter(c,e,tp)
    return c:IsSetCard(0x1aa) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90082.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c90082.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c90082.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c90082.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c90082.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c90082.damfilter(c,tp)
    return c:IsPreviousLocation(LOCATION_GRAVE) and c:GetPreviousControler()==tp
end
function c90082.damcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c90082.damfilter,1,nil,tp)
end
function c90082.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,90082)
    local ct=eg:FilterCount(c90082.damfilter,nil,tp)
    Duel.Damage(1-tp,ct*200,REASON_EFFECT)
end