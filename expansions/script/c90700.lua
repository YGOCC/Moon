--"Software - Antivirus"
local m=90700
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Only One"
    c:SetUniqueOnField(1,0,90700)
    --"Activate"
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --"Inactivatable"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_INACTIVATE)
    e1:SetRange(LOCATION_SZONE)
    e1:SetValue(c90700.effectfilter)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_DISEFFECT)
    e2:SetRange(LOCATION_SZONE)
    e2:SetValue(c90700.effectfilter)
    c:RegisterEffect(e2)
    --"Self Destroy"
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EFFECT_SELF_DESTROY)
    e3:SetCondition(c90700.sdcon)
    c:RegisterEffect(e3)
    --"Search"
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(c90700.thtg)
    e4:SetOperation(c90700.thop)
    c:RegisterEffect(e4)
    --"Return To Hand"
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetCost(aux.bfgcost)
    e5:SetTarget(c90700.thtg1)
    e5:SetOperation(c90700.thop1)
    c:RegisterEffect(e5)
end
function c90700.effectfilter(e,ct)
    local p=e:GetHandler():GetControler()
    local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
    return p==tp and te:GetHandler():IsSetCard(0x1aa) and loc&LOCATION_ONFIELD~=0
end
function c90700.sdfilter(c)
    return c:IsFaceup() and c:IsCode(90069)
end
function c90700.sdcon(e)
    return not Duel.IsExistingMatchingCard(c90700.sdfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c90700.filter(c)
    return c:IsSetCard(0x1aa) and c:IsAbleToHand()
end
function c90700.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c90700.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c90700.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c90700.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c90700.filter1(c)
    return c:IsCode(90069) and c:IsAbleToHand()
end
function c90700.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c90700.filter1,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c90700.thop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c90700.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end