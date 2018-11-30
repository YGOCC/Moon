--"Espadachim - Demonic Claw"
local m=70016
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Cannot Select Battle Target"
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetRange(LOCATION_MZONE)
    e0:SetTargetRange(0,LOCATION_MZONE)
    e0:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e0:SetValue(c70016.atlimit)
    c:RegisterEffect(e0)
    --"Cannot Select Effect Target"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(c70016.efftg)
    e1:SetValue(aux.tgoval)
    c:RegisterEffect(e1)
    --"Search"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(70015,0))
    e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetTarget(c70016.thtg)
    e2:SetOperation(c70016.thop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --"Level Change"
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CHANGE_LEVEL)
    e4:SetCondition(c70016.lvcon)
    e4:SetValue(3)
    c:RegisterEffect(e4)
end
function c70016.atlimit(e,c)
    return c:IsFaceup() and c:IsSetCard(0x509) and c~=e:GetHandler()
end
function c70016.efftg(e,c)
    return c:IsSetCard(0x509) and c~=e:GetHandler()
end
function c70016.filter(c)
    return (c:IsSetCard(0x509) and c:IsType(TYPE_MONSTER)) and not c:IsCode(70016) and c:IsAbleToHand()
end
function c70016.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c70016.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c70016.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c70016.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c70016.lvfilter(c)
    return c:IsFaceup() and c:IsCode(70015)
end
function c70016.lvcon(e)
    return Duel.IsExistingMatchingCard(c70016.lvfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end