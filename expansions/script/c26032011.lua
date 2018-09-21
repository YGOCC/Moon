function c26032011.initial_effect(c)
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
    e2:SetTarget(c26032011.tnfilter)
    c:RegisterEffect(e2)
    --synchro level
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CHANGE_LEVEL)
    e3:SetRange(LOCATION_FZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c26032011.tnfilter)
    e3:SetValue(4)
    c:RegisterEffect(e3)
    --Destroy
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(26032011,0))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_FZONE)
    e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e4:SetCountLimit(1)
    e4:SetCost(c26032011.descost)
    e4:SetTarget(c26032011.destg)
    e4:SetOperation(c26032011.desop)
    c:RegisterEffect(e4)
    --cycle
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(26032011,1))
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetCondition(c26032011.thcon)
    e5:SetTarget(c26032011.thtg)
    e5:SetOperation(c26032011.thop)
    c:RegisterEffect(e5)
end
function c26032011.slevel(e,c)
    local lv=e:GetHandler():GetLevel()
    return 4*65536+lv
end
function c26032011.tnfilter(e,c)
    return c:IsFaceup() and c:IsCode(26032003)
end
function c26032011.cfilter(c)
    return c:IsAbleToGraveAsCost() and (c:IsType(TYPE_MONSTER) or c:IsType(TYPE_FIELD))
end
function c26032011.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c26032011.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c26032011.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,e:GetHandler())
    Duel.SendtoGrave(g,REASON_COST)
end
function c26032011.desfilter(c)
    return c:IsCanBeEffectTarget()
end
function c26032011.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and c26032011.desfilter(chkc) and chkc~=e:GetHandler() end
    if chk==0 then return Duel.IsExistingTarget(c26032011.desfilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c26032011.desfilter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26032011,2))
end
function c26032011.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function c26032011.atktg(e,c)
    return c:IsSetCard(0xb32)
end
function c26032011.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT)
end
function c26032011.thfilter(c)
    return c:IsCode(26032012) and c:IsAbleToHand()
end
function c26032011.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c26032011.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c26032011.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c26032011.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end