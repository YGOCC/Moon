--"Espadachim - Thunder Claw"
local m=70015
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Special Summon"
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(70015,0))
    e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e0:SetCode(EVENT_SUMMON_SUCCESS)
    e0:SetCountLimit(1,70015)
    e0:SetTarget(c70015.sumtg)
    e0:SetOperation(c70015.sumop)
    c:RegisterEffect(e0)
    local e1=e0:Clone()
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e1)
    --"Token"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(70015,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetTarget(c70015.sptg)
    e2:SetOperation(c70015.spop)
    c:RegisterEffect(e2)
    --"Level Change"
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_CHANGE_LEVEL)
    e3:SetCondition(c70015.lvcon)
    e3:SetValue(3)
    c:RegisterEffect(e3)
end
function c70015.filter(c,e,tp)
    return c:IsCode(70016) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c70015.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c70015.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c70015.sumop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c70015.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c70015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c70015.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if not Duel.IsPlayerCanSpecialSummonMonster(tp,70019,0x509,0x4011,800,800,4,RACE_WARRIOR,ATTRIBUTE_DARK) then return end
    for i=1,1 do
        local token=Duel.CreateToken(tp,70019)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetCategory(CATEGORY_DESTROY)
        e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
        e1:SetType(EFFECT_TYPE_IGNITION)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCost(c70015.descost)
        e1:SetTarget(c70015.destarget)
        e1:SetOperation(c70015.desoperation)
        token:RegisterEffect(e1)
    end
end
function c70015.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c70015.desfilter(c)
    return c:IsFaceup()
end
function c70015.destarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c70015.desfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c70015.desfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c70015.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c70015.desoperation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function c70015.lvfilter(c)
    return c:IsFaceup() and c:IsCode(70016)
end
function c70015.lvcon(e)
    return Duel.IsExistingMatchingCard(c70015.lvfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end