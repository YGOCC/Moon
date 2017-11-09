--Wyndbreaker Alexis
function c97671889.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c97671889.spcon)
    c:RegisterEffect(e1)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(97671889,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,97671889)
    e2:SetCost(c97671889.thcost)
    e2:SetTarget(c97671889.thtg)
    e2:SetOperation(c97671889.thop)
    c:RegisterEffect(e2)
end
function c97671889.spcon(e,c)
    if c==nil then return true end
    return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
        and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
        and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c97671889.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c97671889.thfilter(c)
    return c:IsSetCard(0xd70) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c97671889.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c97671889.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c97671889.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c97671889.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
