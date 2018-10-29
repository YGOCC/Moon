--Grimheart Miasma
--Design by Reverie
--Script by NightcoreJack
function c39224963.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,39224963+EFFECT_COUNT_CODE_OATH)
    e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
    e1:SetCondition(c39224963.condition)
    e1:SetTarget(c39224963.target)
    e1:SetOperation(c39224963.activate)
    c:RegisterEffect(e1)
end
function c39224963.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x37f)
end
function c39224963.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c39224963.cfilter,tp,LOCATION_MZONE,0,1,nil)
        and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
end
function c39224963.filter(c)
    return c:IsFaceup() and not (c:IsAttack(0) and c:IsDefense(0) and c:IsDisabled())
end
function c39224963.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c39224963.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c39224963.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c39224963.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    if not c:IsStatus(STATUS_ACT_FROM_HAND) and c:IsLocation(LOCATION_SZONE) then
        e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE+CATEGORY_CONTROL)
    end
end
function c39224963.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local e0=Effect.CreateEffect(c)
        e0:SetType(EFFECT_TYPE_SINGLE)
        e0:SetCode(EFFECT_SET_ATTACK_FINAL)
        e0:SetValue(0)
        e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e0)
        local e1=e0:Clone()
        e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
        tc:RegisterEffect(e1)
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_DISABLE_EFFECT)
        e3:SetValue(RESET_TURN_SET)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e3)
        if not c:IsStatus(STATUS_ACT_FROM_HAND) and c:IsLocation(LOCATION_SZONE) and tc:IsControlerCanBeChanged() and Duel.SelectYesNo(tp,aux.Stringid(98338152,0)) then
            Duel.BreakEffect()
            Duel.GetControl(tc,tp,PHASE_END,1)
        end
    end
end