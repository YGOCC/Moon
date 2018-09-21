function c26032009.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --tuner
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_ADD_TYPE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetValue(TYPE_TUNER)
    e2:SetTarget(c26032009.tnfilter)
    c:RegisterEffect(e2)
    --synchro level
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CHANGE_LEVEL)
    e3:SetRange(LOCATION_FZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c26032009.tnfilter)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --search
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(26032009,1))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_FZONE)
    e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e4:SetCountLimit(1)
    e4:SetCost(c26032009.scost)
    e4:SetTarget(c26032009.stg)
    e4:SetOperation(c26032009.sop)
    c:RegisterEffect(e4)
    --cycle
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(26032009,2))
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetCondition(c26032009.thcon)
    e5:SetTarget(c26032009.thtg)
    e5:SetOperation(c26032009.thop)
    c:RegisterEffect(e5)
end
function c26032009.slevel(e,c)
    local lv=e:GetHandler():GetLevel()
    return 1*65536+lv
end
function c26032009.tnfilter(e,c)
    return c:IsFaceup() and c:IsCode(26032001)
end
function c26032009.sdfilter(c)
    return c:IsAbleToGraveAsCost()
end
function c26032009.scost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c26032009.sdfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c26032009.sdfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,e:GetHandler())
    Duel.SendtoGrave(g,REASON_COST)
end
function c26032009.sfilter(c)
    return c:IsAbleToHand() and c:IsLevel(3)
end
function c26032009.stg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return false end
    local g=Duel.GetMatchingGroup(c26032009.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
    if chk==0 then return g:GetClassCount(Card.GetCode)>=4 end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26032009,2))
end
function c26032009.sop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c26032009.sfilter,tp,LOCATION_DECK,0,nil,e,tp)
    if g:GetCount()<2 then return false end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g1=g:Select(tp,1,1,nil)
    g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g2=g:Select(tp,1,1,nil)
    g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g3=g:Select(tp,1,1,nil)
    g:Remove(Card.IsCode,nil,g3:GetFirst():GetCode())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g4=g:Select(tp,1,1,nil)
    g1:Merge(g2)
    g1:Merge(g3)
    g1:Merge(g4)
    Duel.ConfirmCards(1-tp,g1)
    if g1:GetClassCount(Card.GetAttribute)==4 and g1:GetClassCount(Card.GetAttribute)==4 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local tg=g1:Select(tp,1,1,nil)
        Duel.SendtoHand(tg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tg)
    else
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
        local tg=g1:Select(1-tp,1,1,nil)
        Duel.SendtoHand(tg,nil,REASON_EFFECT)
    end
end

function c26032009.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_EFFECT)
end
function c26032009.thfilter(c)
    return c:IsCode(26032010) and c:IsAbleToHand()
end
function c26032009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c26032009.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c26032009.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c26032009.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end