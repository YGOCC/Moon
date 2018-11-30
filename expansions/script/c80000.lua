--"Espada Demoníaca - Invocation Cut"
local m=80000
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Activate"
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(80000,0))
    e0:SetCategory(CATEGORY_EQUIP)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e0:SetTarget(c80000.target)
    e0:SetOperation(c80000.operation)
    c:RegisterEffect(e0)
    --"Atk UP"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_EQUIP)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(500)
    c:RegisterEffect(e1)
    --"Equip Limit"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EQUIP_LIMIT)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetValue(c80000.eqlimit)
    c:RegisterEffect(e2)
    --"Special Summon"
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(80000,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_BATTLE_DESTROYING)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(c80000.spcon)
    e3:SetTarget(c80000.sptg)
    e3:SetOperation(c80000.spop)
    c:RegisterEffect(e3)
    --"Search"
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(80000,2))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_HAND)
    e4:SetCountLimit(1,80000)
    e4:SetCost(c80000.scost)
    e4:SetTarget(c80000.starget)
    e4:SetOperation(c80000.soperation)
    c:RegisterEffect(e4)
end
function c80000.eqlimit(e,c)
    return c:IsSetCard(0x509)
end
function c80000.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x509)
end
function c80000.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c80000.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c80000.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c80000.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
end
function c80000.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,c,tc)
    end
end
function c80000.spcon(e,tp,eg,ep,ev,re,r,rp)
    local ec=eg:GetFirst()
    local bc=ec:GetBattleTarget()
    return e:GetHandler():GetEquipTarget()==eg:GetFirst() and ec:IsControler(tp)
        and bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE)
end
function c80000.spfilter(c,e,tp)
    return c:IsLevelBelow(4) and c:IsSetCard(0x509) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80000.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c80000.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c80000.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c80000.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c80000.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
        local fid=e:GetHandler():GetFieldID()
        tc:RegisterFlagEffect(80000,RESET_EVENT+RESETS_STANDARD,0,1,fid)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetCountLimit(1)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetLabel(fid)
        e1:SetLabelObject(tc)
        e1:SetCondition(c80000.descon)
        e1:SetOperation(c80000.desop)
        Duel.RegisterEffect(e1,tp)
    end
end
function c80000.descon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc:GetFlagEffectLabel(80000)~=e:GetLabel() then
        e:Reset()
        return false
    else return true end
end
function c80000.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
function c80000.scost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c80000.sfilter(c)
    return c:IsSetCard(0x509) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c80000.starget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
     if chk==0 then return Duel.IsExistingMatchingCard(c80000.sfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
        e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
end
function c80000.soperation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c80000.sfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end