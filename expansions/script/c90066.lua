--"Hacker - Data Protector Master"
local m=90066
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    --"Cannot Attack"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_ATTACK_COST)
    e1:SetCost(c90066.atkcost)
    e1:SetCondition(c90066.atkcon)
    c:RegisterEffect(e1)
    --"Pierce"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90066,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c90066.atkcon)
    e2:SetTarget(c90066.ptarget)
    e2:SetOperation(c90066.poperation)
    c:RegisterEffect(e2)
    --"Switch ATK and DEF"
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(90066,1))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCountLimit(1)
    e3:SetCondition(c90066.defcon)
    e3:SetTarget(c90066.adtg1)
    e3:SetOperation(c90066.adop1)
    c:RegisterEffect(e3)
    --"ATK UP"
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetCode(EFFECT_UPDATE_DEFENSE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c90066.defcon)
    e4:SetValue(c90066.defval)
    c:RegisterEffect(e4)
    --"Indestructable"
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_SZONE,0)
    e5:SetCondition(c90066.defcon)
    e5:SetTarget(c90066.indtg)
    e5:SetValue(1)
    c:RegisterEffect(e5)
    --"Special Summon"
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(90066,2))
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e6:SetCode(EVENT_SPSUMMON_SUCCESS)
    e6:SetRange(LOCATION_GRAVE)
    e6:SetCountLimit(1,90066)
    e6:SetCondition(c90066.spcon)
    e6:SetTarget(c90066.sptg)
    e6:SetOperation(c90066.spop)
    c:RegisterEffect(e6)
end
function c90066.atkcost(e,c,tp,st)
    return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>=2
end
function c90066.atkcon(e)
    return e:GetHandler():IsAttackPos()
end
function c90066.pfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x1aa) and c:IsType(TYPE_NORMAL) and not c:IsHasEffect(EFFECT_PIERCE)
end
function c90066.ptarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(c90066.pfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c90066.pfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c90066.poperation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_PIERCE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end
function c90066.defcon(e)
    return e:GetHandler():IsDefensePos()
end
function c90066.filter(c)
    return c:IsFaceup() and c:IsDefenseAbove(0)
end
function c90066.adtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c90066.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c90066.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c90066.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c90066.adop1(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local atk=tc:GetAttack()
        local def=tc:GetDefense()
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_ATTACK_FINAL)
        e2:SetValue(def)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        local e3=e2:Clone()
        e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
        e3:SetValue(atk)
        tc:RegisterEffect(e3)
    end
end
function c90066.deffilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function c90066.defval(e,c)
    return Duel.GetMatchingGroupCount(c90066.deffilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)*1000
end
function c90066.indtg(e,c)
    return c:GetSequence()<5 and c:IsFaceup()
end
function c90066.cfilter(c,tp)
    return c:IsControler(tp) and c:IsSetCard(0x1aa) and c:IsType(TYPE_LINK) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c90066.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c90066.cfilter,1,nil,tp) and aux.exccon(e)
end
function c90066.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local zone=0
    local lg=eg:Filter(c90066.cfilter,nil,tp)
    for tc in aux.Next(lg) do
        zone=bit.bor(zone,tc:GetLinkedZone())
    end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c90066.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local zone=0
    local lg=eg:Filter(c90066.cfilter,nil,tp)
    for tc in aux.Next(lg) do
        zone=bit.bor(zone,tc:GetLinkedZone())
    end
    if c:IsRelateToEffect(e) and zone~=0 and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP,zone) then
        --"ATK DOWN"
        local e4=Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_FIELD)
        e4:SetCode(EFFECT_UPDATE_ATTACK)
        e4:SetRange(LOCATION_MZONE)
        e4:SetTargetRange(0,LOCATION_MZONE)
        e4:SetValue(c90066.atkval1)
        c:RegisterEffect(e4,true)
        Duel.SpecialSummonComplete()
    end
end
function c90066.atkval1(e,c)
    local rec=c:GetBaseAttack()
    if rec<0 then rec=0 end
    return rec*-1
end