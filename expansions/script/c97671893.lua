--Wyndbreaker Kingdom
function c97671893.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --atk/def up
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd70))
    e2:SetValue(300)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)
    --To Hand
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e4:SetCode(EVENT_RELEASE)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c97671893.thcon)
    e4:SetTarget(c97671893.thtg)
    e4:SetOperation(c97671893.thop)
    c:RegisterEffect(e4)
    --to hand
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCountLimit(1,97671893)
    e4:SetCondition(c97671893.thcon2)
    e4:SetTarget(c97671893.thtg2)
    e4:SetOperation(c97671893.thop2)
    c:RegisterEffect(e4)
end
function c97671893.thfilter(c,tp)
    return c:IsSetCard(0xd70) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE+LOCATION_HAND) and c:GetPreviousControler()==tp
end
function c97671893.thcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c97671893.thfilter,1,nil,tp)
end
function c97671893.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=eg:Filter(c97671893.thfilter,nil,tp)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c97671893.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local rg=g:Select(tp,1,1,nil)
    if rg:GetCount()>0 then
        Duel.SendtoHand(rg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,rg)
    end
end
function c97671893.thcon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c97671893.thfilter2(c)
    return c:IsSetCard(0xd70) and not c:IsCode(97671893) and c:IsAbleToHand()
end
function c97671893.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c97671893.thfilter2,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c97671893.thop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c97671893.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end