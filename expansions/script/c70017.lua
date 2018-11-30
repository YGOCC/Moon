--"Espadachim - Tuning Claw"
local m=70017
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Synchro Materials"
    c:EnableReviveLimit()
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,70015),aux.FilterBoolFunction(Card.IsCode,70016),1,1)
    --"Tuner monster"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(70017,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c70017.target)
    e1:SetOperation(c70017.operation)
    c:RegisterEffect(e1)
    --"Special Summon Token"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(70017,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetTarget(c70017.tokentarget)
    e2:SetOperation(c70017.tokenoperation)
    c:RegisterEffect(e2)
end
function c70017.filter(c)
    return c:IsFaceup() and c:IsLevelBelow(5) and c:IsSetCard(0x509) and not c:IsType(TYPE_TUNER)
end
function c70017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c70017.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c70017.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c70017.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c70017.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_ADD_TYPE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(TYPE_TUNER)
        tc:RegisterEffect(e1)
    end
end
function c70017.tokentarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,tp,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function c70017.tokenoperation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
    if not Duel.IsPlayerCanSpecialSummonMonster(tp,70018,0x509,0x4011,0,0,1,RACE_WARRIOR,ATTRIBUTE_LIGHT) then return end
    for i=1,2 do
        local token=Duel.CreateToken(tp,70018)
        Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_ADD_TYPE)
        e1:SetValue(TYPE_TUNER)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        token:RegisterEffect(e1)
    end
end