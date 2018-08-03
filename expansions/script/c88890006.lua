--Subzero Crystal - Guardian Nethaninail
function c88890006.initial_effect(c)
    c:EnableReviveLimit()
    --(1) Special Summon condition
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c88890006.splimit)
    c:RegisterEffect(e1)
    --(2) add to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(88890006,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c88890006.atttg1)
    e2:SetOperation(c88890006.attop1)
    c:RegisterEffect(e2)
    --(3) Pay or Destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(88890006,1))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c88890006.paycon)
    e3:SetOperation(c88890006.payop)
    c:RegisterEffect(e3)
    --(4) To hand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(88890006,2))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_HAND)
    e4:SetCost(c88890006.thcost)
    e4:SetTarget(c88890006.thtg)
    e4:SetOperation(c88890006.thop)
    c:RegisterEffect(e4)
    --(5) Place in S/T Zone
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
    e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e5:SetCondition(c88890006.stzcon)
    e5:SetOperation(c88890006.stzop)
    c:RegisterEffect(e5)
    --(7) add
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(88890006,4))
    e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e6:SetCode(EVENT_TO_GRAVE)
    e6:SetCondition(c88890006.thcon)
    e6:SetTarget(c88890006.thtg1)
    e6:SetOperation(c88890006.thop1)
    c:RegisterEffect(e6)
end
--(1) Special Summon condition
function c88890006.splimit(e,se,sp,st)
    return se:GetHandler():IsSetCard(0x902)
end
--(2) add to hand
function c88890006.atttg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsControler(tp) and chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil) end
    local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c88890006.attop1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e1:SetValue(ATTRIBUTE_WIND)
    e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(1150)
    e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e2)
end
--(3) Pay or Destroy
function c88890006.paycon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c88890006.payop(e,tp,eg,ep,ev,re,r,rp)
    Duel.HintSelection(Group.FromCards(e:GetHandler()))
    if Duel.CheckLPCost(tp,500) and Duel.SelectYesNo(tp,aux.Stringid(88890006,1)) then
        Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(88890006,5))
        Duel.PayLPCost(tp,500)
    else
        Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(88890006,6))
        Duel.Destroy(e:GetHandler(),REASON_COST)
    end
end
--(4) To hand
function c88890006.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c88890006.thfilter(c)
    return c:IsSetCard(0x902) and c:GetType()==TYPE_SPELL+TYPE_RITUAL and c:IsAbleToHand()
end
function c88890006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c88890006.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88890006.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c88890006.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--(5) Place in S/T Zone
function c88890006.stzcon(e)
    local c=e:GetHandler()
    return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c88890006.stzop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    --Continuous Spell
    local e1=Effect.CreateEffect(c)
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fc0000)
    e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
    c:RegisterEffect(e1)
    Duel.RaiseEvent(c,EVENT_CUSTOM+88890010,e,0,tp,0,0)
end
--(7) add
function c88890006.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end
function c88890006.thfilter1(c)
    return c:IsSetCard(0x902) and c:IsAbleToHand()
end
function c88890006.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c88890006.thfilter1,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88890006.thop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c88890006.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end