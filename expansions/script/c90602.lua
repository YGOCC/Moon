--"Software - Exploit"
local m=90602
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Only One"
    c:SetUniqueOnField(1,0,90602)
    --"Activate"
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --"Discard Deck"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90602,0))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetCategory(CATEGORY_DECKDES)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c90602.discon)
    e1:SetTarget(c90602.distg)
    e1:SetOperation(c90602.disop)
    c:RegisterEffect(e1)
    --"ATK UP"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90602,1))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,90602)
    e2:SetCondition(c90602.condition)
    e2:SetTarget(c90602.target)
    e2:SetOperation(c90602.operation)
    c:RegisterEffect(e2)
    --"Add 2 'Hacker' Pendulum Cards"
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCost(aux.bfgcost)
    e3:SetTarget(c90602.thtarget)
    e3:SetOperation(c90602.thactivate)
    c:RegisterEffect(e3)
end
function c90602.discon(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end
function c90602.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c90602.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetControler()~=tp or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    local ct=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x1aa)
    if ct>0 then
        Duel.DiscardDeck(1-tp,ct,REASON_EFFECT)
    end
end
function c90602.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c90602.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x1aa) and c:IsType(TYPE_PENDULUM)
end
function c90602.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c90602.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c90602.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,c90602.filter,tp,LOCATION_MZONE,0,1,1,nil)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_ATTACK)
    e2:SetProperty(EFFECT_FLAG_OATH)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c90602.ftarget)
    e2:SetLabel(g:GetFirst():GetFieldID())
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function c90602.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local atk=0
        local g=Duel.GetMatchingGroup(c90602.filter,tp,LOCATION_MZONE,LOCATION_MZONE,tc)
        local bc=g:GetFirst()
        while bc do
            atk=atk+bc:GetAttack()
            bc=g:GetNext()
        end
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e1:SetValue(atk)
        tc:RegisterEffect(e1)
    end
end
function c90602.ftarget(e,c)
    return e:GetLabel()~=c:GetFieldID()
end
function c90602.thfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x1aa) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c90602.thtarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetMatchingGroup(c90602.thfilter,tp,LOCATION_EXTRA,0,nil)
        return g:GetClassCount(Card.GetCode)>=2
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_EXTRA)
end
function c90602.thactivate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c90602.thfilter,tp,LOCATION_EXTRA,0,nil)
    if g:GetClassCount(Card.GetCode)>=2 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g1=g:Select(tp,1,1,nil)
        g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g2=g:Select(tp,1,1,nil)
        g1:Merge(g2)
        Duel.SendtoHand(g1,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g1)
    end
end