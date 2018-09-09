--Subzero Crystal - Guardian Sorteactra
function c88890009.initial_effect(c)
    c:EnableReviveLimit()
    --(1) Special Summon condition
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c88890009.splimit)
    c:RegisterEffect(e1)
    --(2) Banish
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(88890009,0))
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c88890009.rmtg)
    e2:SetOperation(c88890009.rmop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(c88890009.rmcon)
    c:RegisterEffect(e3)
    --(3) Pay or Destroy
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(88890009,1))
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c88890009.paycon)
    e4:SetOperation(c88890009.payop)
    c:RegisterEffect(e4)
    --(4) To hand
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(88890009,2))
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_HAND)
    e5:SetCost(c88890009.thcost)
    e5:SetTarget(c88890009.thtg)
    e5:SetOperation(c88890009.thop)
    c:RegisterEffect(e5)
    --(5) Place in S/T Zone
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
    e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e6:SetCondition(c88890009.stzcon)
    e6:SetOperation(c88890009.stzop)
    c:RegisterEffect(e6)
    --(7) add
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(88890009,4))
    e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e7:SetCode(EVENT_TO_GRAVE)
    e7:SetCondition(c88890009.thcon)
    e7:SetTarget(c88890009.thtg1)
    e7:SetOperation(c88890009.thop1)
    c:RegisterEffect(e7)
end
--(1) Special Summon condition
function c88890009.splimit(e,se,sp,st)
    return se:GetHandler():IsSetCard(0x902)
end
--(2) Banish
function c88890009.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsType(TYPE_SPELL+TYPE_CONTINUOUS) and not e:GetHandler():IsType(TYPE_EQUIP)
end
function c88890009.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c88890009.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Remove(tc,tc:GetPosition(),REASON_EFFECT+REASON_TEMPORARY)~=0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetCountLimit(1)
        e1:SetLabelObject(tc)
        e1:SetOperation(c88890009.retop)
        Duel.RegisterEffect(e1,tp)
    end
end
function c88890009.retop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ReturnToField(e:GetLabelObject())
end
--(3) Pay or Destroy
function c88890009.paycon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c88890009.payop(e,tp,eg,ep,ev,re,r,rp)
    Duel.HintSelection(Group.FromCards(e:GetHandler()))
    if Duel.CheckLPCost(tp,600) and Duel.SelectYesNo(tp,aux.Stringid(88890009,1)) then
        Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(88890009,5))
        Duel.PayLPCost(tp,600)
    else
        Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(88890009,6))
        Duel.Destroy(e:GetHandler(),REASON_COST)
    end
end
--(4) To hand
function c88890009.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c88890009.thfilter(c)
    return c:IsSetCard(0x902) and c:GetType()==TYPE_SPELL+TYPE_RITUAL and c:IsAbleToHand()
end
function c88890009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c88890009.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88890009.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c88890009.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--(5) Place in S/T Zone
function c88890009.stzcon(e)
    local c=e:GetHandler()
    return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c88890009.stzop(e,tp,eg,ep,ev,re,r,rp)
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
function c88890009.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end
function c88890009.thfilter1(c)
    return c:IsSetCard(0x902) and c:IsAbleToHand()
end
function c88890009.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c88890009.thfilter1,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88890009.thop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c88890009.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end