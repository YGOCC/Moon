--"Software - Data Recovery"
local m=90078
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Activate"
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --"To Hand"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90078,0))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1,90078)
    e1:SetCondition(c90078.rccon)
    e1:SetTarget(c90078.rctg)
    e1:SetOperation(c90078.rcop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90078,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetTarget(c90078.thtg)
    e2:SetOperation(c90078.thop)
    c:RegisterEffect(e2)
    --"Indestructable"
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetOperation(c90078.indop)
    c:RegisterEffect(e3)
end
function c90078.rccon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,2,nil,0x1aa)
end
function c90078.rcfilter(c,lsc,rsc)
    local lv=c:GetLevel()
    return lv>lsc and lv<rsc and c:IsAbleToHand()
end
function c90078.rctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()
    local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetRightScale()
    if lsc>rsc then lsc,rsc=rsc,lsc end
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c90078.rcfilter(chkc,lsc,rsc) end
    if chk==0 then return Duel.IsExistingTarget(c90078.rcfilter,tp,LOCATION_GRAVE,0,2,nil,lsc,rsc) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c90078.rcfilter,tp,LOCATION_GRAVE,0,2,2,nil,lsc,rsc)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c90078.rcop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    if sg:GetCount()>0 then
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
    end
end
function c90078.thfilter1(c,tp)
    return c:IsSetCard(0x1aa) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
        and Duel.IsExistingMatchingCard(c90078.thfilter2,tp,LOCATION_DECK,0,1,c)
end
function c90078.thfilter2(c)
    return c:IsCode(90079) and c:IsAbleToHand()
end
function c90078.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c90078.thfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c90078.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g1=Duel.SelectMatchingCard(tp,c90078.thfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
    if g1:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g2=Duel.SelectMatchingCard(tp,c90078.thfilter2,tp,LOCATION_DECK,0,1,1,g1:GetFirst())
        g1:Merge(g2)
        Duel.SendtoHand(g1,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g1)
    end
end
function c90078.indop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e1:SetTargetRange(LOCATION_PZONE,LOCATION_PZONE)
    e1:SetValue(aux.indoval)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetCondition(c90078.discon)
    e2:SetOperation(c90078.disop)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function c90078.indfilter(c)
    return c:IsSetCard(0x1aa) and c:IsLocation(LOCATION_PZONE)
end
function c90078.discon(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(c90078.indfilter,1,nil) and ep~=tp
end
function c90078.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
end
