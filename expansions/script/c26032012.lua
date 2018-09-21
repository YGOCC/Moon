function c26032012.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --tuner
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_ADD_TYPE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetValue(TYPE_TUNER)
    e2:SetTarget(c26032012.tnfilter)
    c:RegisterEffect(e2)
    --synchro level
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CHANGE_LEVEL)
    e3:SetRange(LOCATION_FZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c26032012.tnfilter)
    e3:SetValue(5)
    c:RegisterEffect(e3)
    --disable
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(26032012,1))
    e4:SetCategory(CATEGORY_DISABLE)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetRange(LOCATION_FZONE)
    e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e4:SetCost(c26032012.discost)
    e4:SetTarget(c26032012.distg)
    e4:SetOperation(c26032012.disop)
    c:RegisterEffect(e4)
    --cycle
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(26032012,2))
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetCondition(c26032012.thcon)
    e5:SetTarget(c26032012.thtg)
    e5:SetOperation(c26032012.thop)
    c:RegisterEffect(e5)
end
function c26032012.slevel(e,c)
    local lv=e:GetHandler():GetLevel()
    return 5*65536+lv
end
function c26032012.tnfilter(e,c)
    return c:IsFaceup() and c:IsCode(26032004)
end
function c26032012.cfilter(c)
    return c:IsAbleToGraveAsCost() and (c:IsType(TYPE_MONSTER) or c:IsType(TYPE_FIELD))
end
function c26032012.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c26032012.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c26032012.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,e:GetHandler())
    Duel.SendtoGrave(g,REASON_COST)
end
function c26032012.disfilter(c,tp)
    return c:IsFaceup() and c:GetSummonPlayer()~=tp
end
function c26032012.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c26032012.disfilter,1,nil,tp) end
    local g=eg:Filter(c26032012.disfilter,nil,nil)
    Duel.SetTargetCard(eg)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c26032012.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local g=eg:Filter(c26032012.disfilter,nil,nil)
    local tc=g:GetFirst()
    while tc do
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2)
        local e3=e1:Clone()
        e3:SetCode(EFFECT_CANNOT_ATTACK)
        tc:RegisterEffect(e3)
        tc=g:GetNext()
    end
end
function c26032012.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT)
end
function c26032012.thfilter(c)
    return c:IsCode(26032009) and c:IsAbleToHand()
end
function c26032012.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c26032012.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c26032012.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c26032012.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end