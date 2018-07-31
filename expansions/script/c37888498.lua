--Celestian Temple
function c37888498.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --LP up
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(37888498,0))
    e2:SetCategory(CATEGORY_RECOVER)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_DECK)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCondition(c37888498.condition)
    e2:SetTarget(c37888498.target)
    e2:SetOperation(c37888498.operation)
    c:RegisterEffect(e2)
    --place
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(37888498,1))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c37888498.tftg)
    e3:SetOperation(c37888498.tfop)
    c:RegisterEffect(e3)
    --add 1 from deck
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(37888498,2))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_DECK)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c37888498.condition1)
    e4:SetTarget(c37888498.thtg)
    e4:SetOperation(c37888498.thop)
    c:RegisterEffect(e4)
end
function c37888498.condition(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return eg:GetCount()==1 and tc:IsControler(tp) and tc:IsSetCard(0xebb)
end
function c37888498.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(500)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,500)
end
function c37888498.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
        Duel.Recover(p,d,REASON_EFFECT)
    end
end
function c37888498.tffilter(c)
    return c:IsSetCard(0xebb) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c37888498.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c37888498.tffilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c37888498.tfop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c37888498.tffilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fc0000)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        tc:RegisterEffect(e1)
    end
end
function c37888498.condition1(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return eg:GetCount()==1 and tc:IsControler(tp) and tc:IsSetCard(0xebb) and tc:IsType(TYPE_MONSTER)
end
function c37888498.thfilter(c)
    return c:IsSetCard(0xebb) and c:IsAbleToHand()
end
function c37888498.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c37888498.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c37888498.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c37888498.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end