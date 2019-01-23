--"Wished Network's Key"
local m=90081
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Activate"
    local e0=Effect.CreateEffect(c)
    e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetCondition(c90081.condition)
    e0:SetCost(c90081.cost)
    e0:SetTarget(c90081.target)
    e0:SetOperation(c90081.activate)
    c:RegisterEffect(e0)
    --"ATK UP"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_EQUIP)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(c90081.atkval)
    c:RegisterEffect(e1)
    --"Chain Attack"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90081,0))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c90081.cacon)
    e2:SetCost(c90081.cacost)
    e2:SetTarget(c90081.catg)
    e2:SetOperation(c90081.caop)
    c:RegisterEffect(e2)
    --"Special Summon"
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_BATTLE_DESTROYED)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCost(aux.bfgcost)
    e3:SetCondition(c90081.sscondition)
    e3:SetTarget(c90081.sstarget)
    e3:SetOperation(c90081.ssactivate)
    c:RegisterEffect(e3)
end
function c90081.cfilter(c)
    return c:IsType(TYPE_LINK) and c:IsSetCard(0x1aa)
end
function c90081.condition(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c90081.cfilter,tp,LOCATION_GRAVE,0,nil)
    return g:GetClassCount(Card.GetCode)>=4
end
function c90081.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local c=e:GetHandler()
    local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_REMAIN_FIELD)
    e1:SetProperty(EFFECT_FLAG_OATH)
    e1:SetReset(RESET_CHAIN)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_DISABLED)
    e2:SetOperation(c90081.tgop)
    e2:SetLabel(cid)
    e2:SetReset(RESET_CHAIN)
    Duel.RegisterEffect(e2,tp)
end
function c90081.tgop(e,tp,eg,ep,ev,re,r,rp)
    local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
    if cid~=e:GetLabel() then return end
    if e:GetOwner():IsRelateToChain(ev) then
        e:GetOwner():CancelToGrave(false)
    end
end
function c90081.filter(c,e,tp)
    return c:IsCode(90077) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c90081.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
        and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
        and Duel.IsExistingMatchingCard(c90081.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c90081.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCountFromEx(tp)<=0 or not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c90081.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc and Duel.SpecialSummonStep(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) then
        if c:IsRelateToEffect(e) and not c:IsStatus(STATUS_LEAVE_CONFIRMED) then
            Duel.Equip(tp,c,tc)
            --"Add Equip limit"
            local e1=Effect.CreateEffect(tc)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e1:SetValue(c90081.eqlimit)
            c:RegisterEffect(e1)
        end
        local fid=c:GetFieldID()
        tc:RegisterFlagEffect(90081,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_PHASE+PHASE_END)
        e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e2:SetCountLimit(1)
        e2:SetLabel(fid)
        e2:SetLabelObject(tc)
        e2:SetCondition(c90081.rmcon)
        e2:SetOperation(c90081.rmop)
        Duel.RegisterEffect(e2,tp)
        Duel.SpecialSummonComplete()
        tc:CompleteProcedure()
    elseif c:IsRelateToEffect(e) and not c:IsStatus(STATUS_LEAVE_CONFIRMED) then
        c:CancelToGrave(false)
    end
end
function c90081.eqlimit(e,c)
    return e:GetOwner()==c
end
function c90081.rmcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc:GetFlagEffectLabel(90081)~=e:GetLabel() then
        e:Reset()
        return false
    else return true end
end
function c90081.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
function c90081.atkfilter(c)
    return c90081.cfilter(c) and c:GetAttack()>0
end
function c90081.atkval(e,c)
    local g=Duel.GetMatchingGroup(c90081.atkfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
    return g:GetSum(Card.GetAttack)
end
function c90081.cacon(e,tp,eg,ep,ev,re,r,rp)
    local ec=e:GetHandler():GetEquipTarget()
    return ec and eg:IsContains(ec)
end
function c90081.cafilter(c)
    return c90081.cfilter(c) and c:IsAbleToRemoveAsCost()
end
function c90081.cacost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c90081.cafilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c90081.cafilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c90081.catg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local ec=c:GetEquipTarget()
    if chk==0 then return ec:IsChainAttackable(0,true) end
end
function c90081.caop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ec=c:GetEquipTarget()
    if not ec:IsRelateToBattle() then return end
    Duel.ChainAttack()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE+PHASE_DAMAGE_CAL)
    ec:RegisterEffect(e1)
end
function c90081.ssfilter0(c,tp)
    local rc=c:GetReasonCard()
    return c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE)
        and rc:IsSetCard(0x1aa) and rc:IsControler(tp) and rc:IsRelateToBattle()
end
function c90081.sscondition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c90081.ssfilter0,1,nil,tp)
end
function c90081.ssfilter1(c,e,tp)
    return c:IsSetCard(0x1aa) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90081.sstarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c90081.ssfilter1(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c90081.ssfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c90081.ssfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c90081.ssactivate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end