--"Hacker - String, The Knowledge Eater"
local m=90061
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Pendulum Attribute"
    aux.EnablePendulumAttribute(c)
    --"Search"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90061,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTarget(c90061.thtg)
    e1:SetOperation(c90061.thop)
    c:RegisterEffect(e1)
    --"Handes"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90061,1))
    e2:SetCategory(CATEGORY_HANDES)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCode(EVENT_BATTLE_DAMAGE)
    e2:SetCondition(c90061.condition)
    e2:SetTarget(c90061.target)
    e2:SetOperation(c90061.operation)
    c:RegisterEffect(e2)
end
function c90061.thfilter1(c,tp)
    return c:IsSetCard(0x1aa) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
        and Duel.IsExistingMatchingCard(c90061.thfilter2,tp,LOCATION_DECK,0,1,c)
end
function c90061.thfilter2(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c90061.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c90061.thfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c90061.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g1=Duel.SelectMatchingCard(tp,c90061.thfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
    if g1:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g2=Duel.SelectMatchingCard(tp,c90061.thfilter2,tp,LOCATION_DECK,0,1,1,g1:GetFirst())
        g1:Merge(g2)
        Duel.SendtoHand(g1,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g1)
    end
end
function c90061.condition(e,tp,eg,ep,ev,re,r,rp)
    local rc=eg:GetFirst()
    return ep~=tp and rc:IsControler(tp) and rc:IsSetCard(0x1aa)
end
function c90061.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function c90061.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetFieldGroup(ep,LOCATION_HAND,0,nil)
    local sg=g:RandomSelect(ep,1)
    Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end