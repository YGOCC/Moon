--Subzero Crystal - Guardian Ecentramite
function c88890002.initial_effect(c)
    c:EnableReviveLimit()
    --(1) Special Summon condition
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c88890002.splimit)
    c:RegisterEffect(e1)
    --(2) add to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(88890002,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c88890002.thtg2)
    e2:SetOperation(c88890002.thop2)
    c:RegisterEffect(e2)
    --(3) Pay or Destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(88890002,1))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c88890002.paycon)
    e3:SetOperation(c88890002.payop)
    c:RegisterEffect(e3)
    --(4) To hand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(88890002,2))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_HAND)
    e4:SetCost(c88890002.thcost)
    e4:SetTarget(c88890002.thtg)
    e4:SetOperation(c88890002.thop)
    c:RegisterEffect(e4)
    --(5) Place in S/T Zone
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
    e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e5:SetCondition(c88890002.stzcon)
    e5:SetOperation(c88890002.stzop)
    c:RegisterEffect(e5)
    --(6) can't normal summon
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_CANNOT_SUMMON)
    e6:SetRange(LOCATION_SZONE)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetTargetRange(0,1)
    e6:SetCondition(c88890002.efcon)
    e6:SetTarget(c88890002.efval)
    c:RegisterEffect(e6)
    --(7) add
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(88890002,4))
    e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e7:SetCode(EVENT_TO_GRAVE)
    e7:SetCondition(c88890002.thcon)
    e7:SetTarget(c88890002.thtg1)
    e7:SetOperation(c88890002.thop1)
    c:RegisterEffect(e7)
end
--(1) Special Summon condition
function c88890002.splimit(e,se,sp,st)
    return se:GetHandler():IsSetCard(0x902)
end
--(2) add to hand
function c88890002.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return false end
        local g=Duel.GetDecktopGroup(tp,3)
        local result=g:FilterCount(Card.IsAbleToHand,nil)>0
        return result
    end
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c88890002.thop2(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    Duel.ConfirmDecktop(p,3)
    local g=Duel.GetDecktopGroup(p,3)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
        local sg=g:RandomSelect(1-p,1,1,nil)
        if sg:GetFirst():IsAbleToHand() then
            Duel.SendtoHand(sg,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-p,sg)
            Duel.ShuffleHand(p)
        else
            Duel.SendtoGrave(sg,REASON_RULE)
        end
        Duel.ShuffleDeck(p)
    end
end
--(3) Pay or Destroy
function c88890002.paycon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c88890002.payop(e,tp,eg,ep,ev,re,r,rp)
    Duel.HintSelection(Group.FromCards(e:GetHandler()))
    if Duel.CheckLPCost(tp,500) and Duel.SelectYesNo(tp,aux.Stringid(88890002,1)) then
        Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(88890002,5))
        Duel.PayLPCost(tp,500)
    else
        Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(88890002,6))
        Duel.Destroy(e:GetHandler(),REASON_COST)
    end
end
--(4) To hand
function c88890002.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c88890002.thfilter(c)
    return c:IsSetCard(0x902) and c:GetType()==TYPE_SPELL+TYPE_RITUAL and c:IsAbleToHand()
end
function c88890002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c88890002.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88890002.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c88890002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--(5) Place in S/T Zone
function c88890002.stzcon(e)
    local c=e:GetHandler()
    return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c88890002.stzop(e,tp,eg,ep,ev,re,r,rp)
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
function c88890002.efcon(e)
    return e:GetHandler():IsType(TYPE_SPELL+TYPE_CONTINUOUS) and e:GetHandler():IsFaceup() and not e:GetHandler():IsType(TYPE_EQUIP)
end
function c88890002.efval(e,c)
    return not c:IsAttribute(ATTRIBUTE_LIGHT)
end
--(7) add
function c88890002.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end
function c88890002.thfilter1(c)
    return c:IsSetCard(0x902) and c:IsAbleToHand()
end
function c88890002.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c88890002.thfilter1,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88890002.thop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c88890002.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end