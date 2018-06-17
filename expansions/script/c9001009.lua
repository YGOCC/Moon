--Ritualia Nexus
local m=9001009
local card=_G["c"..m]
function card.initial_effect(c)
        --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m)
    e1:SetTarget(card.target)
    e1:SetOperation(card.activate)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_FZONE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1)
    e3:SetCost(card.descost)
    e3:SetTarget(card.destarget)
    e3:SetOperation(card.desop)
    c:RegisterEffect(e3)
end

function card.desfilter(c)
    return c:IsSetCard(0x1f5) and c:IsType(TYPE_PENDULUM) and c:IsAbleToGraveAsCost() and c:IsFaceup()
end
function card.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(card.desfilter,tp,LOCATION_EXTRA,0,2,nil) end
    local g=Duel.SelectMatchingCard(tp,card.desfilter,tp,LOCATION_EXTRA,0,2,2,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function card.destarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(card.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function card.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,card.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function card.thfilter(c)
    return c:IsSetCard(0x1f5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function card.sfilter(c)
    return c:IsSetCard(0x1f5) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() and c:IsType(TYPE_RITUAL)
end
function card.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(card.sfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function card.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,card.sfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g)
end
end

