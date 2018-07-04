--Subzero Crystal - Guardian Pheoneta
function c88890008.initial_effect(c)
    c:EnableReviveLimit()
    --(1) Special Summon condition
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c88890008.splimit)
    c:RegisterEffect(e1)
    --(2) Effect for card
    --local e2=Effect.CreateEffect(c)
    --e2:SetType(EFFECT_TYPE_SINGLE)
    --e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    --e2:SetRange(LOCATION_MZONE)
    --e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    --e2:SetCountLimit(1)
    --e2:SetValue(c88890008.indct)
    --e2:SetCost(c88890008.indcost)
    --e2:SetOperation(c88890008.indop)
    --c:RegisterEffect(e2)
    --(3) Pay or Destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(88890008,1))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c88890008.paycon)
    e3:SetOperation(c88890008.payop)
    c:RegisterEffect(e3)
    --(4) To hand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(88890008,2))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_HAND)
    e4:SetCost(c88890008.thcost)
    e4:SetTarget(c88890008.thtg)
    e4:SetOperation(c88890008.thop)
    c:RegisterEffect(e4)
    --(5) Place in S/T Zone
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
    e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e5:SetCondition(c88890008.stzcon)
    e5:SetOperation(c88890008.stzop)
    c:RegisterEffect(e5)
    --(6) can't normal summon
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_CANNOT_SUMMON)
    e6:SetRange(LOCATION_SZONE)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetTargetRange(0,1)
    e6:SetCondition(c88890008.efcon)
    e6:SetValue(c88890008.efval)
    c:RegisterEffect(e6)
    --(7) add
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(88890008,4))
    e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e7:SetCode(EVENT_TO_GRAVE)
    e7:SetCondition(c88890008.thcon)
    e7:SetTarget(c88890008.thtg1)
    e7:SetOperation(c88890008.thop1)
    c:RegisterEffect(e7)
end
--(1) Special Summon condition
function c88890008.splimit(e,se,sp,st)
    return se:GetHandler():IsSetCard(0x902)
end
--(2) Effect for card
--function c88890008.indcost(e,tp,eg,ep,ev,re,r,rp,chk)
    --if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    --Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    --local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,e:GetHandler())
    --Duel.Remove(g,POS_FACEUP,REASON_COST)
--end
--function c88890008.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
    
--end
--function c88890008.indop(e,tp,eg,ep,ev,re,r,rp)
    
--end
--(3) Pay or Destroy
function c88890008.paycon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c88890008.payop(e,tp,eg,ep,ev,re,r,rp)
    Duel.HintSelection(Group.FromCards(e:GetHandler()))
    if Duel.CheckLPCost(tp,300) and Duel.SelectYesNo(tp,aux.Stringid(88890008,1)) then
        Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(88890008,5))
        Duel.PayLPCost(tp,300)
    else
        Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(88890008,6))
        Duel.Destroy(e:GetHandler(),REASON_COST)
    end
end
--(4) To hand
function c88890008.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c88890008.thfilter(c)
    return c:IsSetCard(0x902) and c:GetType()==TYPE_SPELL+TYPE_RITUAL and c:IsAbleToHand()
end
function c88890008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c88890008.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88890008.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c88890008.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--(5) Place in S/T Zone
function c88890008.stzcon(e)
    local c=e:GetHandler()
    return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c88890008.stzop(e,tp,eg,ep,ev,re,r,rp)
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
--(6) can't normal summon
function c88890008.efcon(e)
    return e:GetHandler():IsType(TYPE_SPELL+TYPE_CONTINUOUS) and not e:GetHandler():IsType(TYPE_EQUIP)
end
function c88890008.efval(e,c)
    return c:IsAttribute(ATTRIBUTE_FIRE)
end
--(7) add
function c88890008.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end
function c88890008.thfilter1(c)
    return c:IsSetCard(0x902) and c:IsAbleToHand()
end
function c88890008.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c88890008.thfilter1,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88890008.thop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c88890008.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end