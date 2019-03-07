--Dokurorider Yakuza Red Hot
--Script by TaxingCorn117
function c66823466.initial_effect(c)
    --tohand
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(66823466,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,66823466)
    e1:SetTarget(c66823466.target)
    e1:SetOperation(c66823466.operation)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --effect gain
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_BE_MATERIAL)
    e4:SetCondition(c66823466.mtcon)
    e4:SetOperation(c66823466.mtop)
    c:RegisterEffect(e4)
end
--filters
function c66823466.filter(c)
    return (c:IsCode(99721536) or c:IsSetCard(0x1e0)) and c:IsType(TYPE_SPELL) and not c:IsCode(66823466) and c:IsAbleToHand()
end
function c66823466.efilter(e,te)
    return te:IsActiveType(TYPE_MONSTER)
end
--tohand
function c66823466.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c66823466.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c66823466.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c66823466.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
--effect gain
function c66823466.mtcon(e,tp,eg,ep,ev,re,r,rp)
    local rc=eg:GetFirst()
    return r==REASON_RITUAL and (rc:IsCode(99721536) or rc:IsSetCard(0x1e0))
end
function c66823466.mtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(66823466,1))
    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_EXTRA_ATTACK)
    e1:SetValue(1)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    rc:RegisterEffect(e1,true)
end