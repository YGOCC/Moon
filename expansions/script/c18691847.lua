--THE EMBLEM OF THE ASSASSIN
function c18691847.initial_effect(c)
    c:SetUniqueOnField(1,0,18691847)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --indestructable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e2:SetTarget(c18691847.infilter)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    c:RegisterEffect(e3)
    --to hand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(18691847,0))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCountLimit(1)
    e4:SetCost(aux.bfgcost)
    e4:SetTarget(c18691847.thtg)
    e4:SetOperation(c18691847.thop)
    c:RegisterEffect(e4)
end
function c18691847.infilter(e,c)
    return bit.band(c:GetType(),0x2)==0x2 and c:GetCode()~=18691847
end
function c18691847.thfilter(c)
    return c:IsSetCard(0x50e) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c18691847.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c18691847.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c18691847.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c18691847.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end


