--ASSASSIN - SIMON
function c18591814.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x50e),4,2)
    c:EnableReviveLimit()
    --SEARCH
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(18591814,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c18591814.thcon)
    e1:SetTarget(c18591814.thtg)
    e1:SetOperation(c18591814.thop)
    c:RegisterEffect(e1)
end
c18591814.xyz_ASSASSIN=18591816
function c18591814.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c18591814.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c18591814.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c18591814.thfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c18591814.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c18591814.thfilter,tp,LOCATION_DECK,0,2,2,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end