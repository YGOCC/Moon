--Over-wind Leap
function c26064009.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE)
    e1:SetTarget(c26064009.target)
    c:RegisterEffect(e1)
    --direct attack
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DIRECT_ATTACK)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x664))
    c:RegisterEffect(e2)
--damage
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DAMAGE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EVENT_BATTLE_DAMAGE)
    e3:SetCondition(c26064009.damcon)
    e3:SetOperation(c26064009.damop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e4:SetCondition(c26064009.rdcon)
    e4:SetOperation(c26064009.rdop)
    c:RegisterEffect(e4)
--to defense
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_DAMAGE_STEP_END)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCondition(c26064009.flcon)
    e5:SetOperation(c26064009.flop)
    c:RegisterEffect(e5)
--Singularity
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetCode(26064009)
    e6:SetRange(LOCATION_SZONE)
    e6:SetTargetRange(1,1)
    c:RegisterEffect(e6)
end
function c26064009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFacedown() end
    if chk==0 then return true end
    if Duel.IsExistingTarget(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
        and Duel.SelectYesNo(tp,aux.Stringid(26064009,0)) then
        e:SetCategory(CATEGORY_POSITION)
        e:SetProperty(EFFECT_FLAG_CARD_TARGET)
        e:SetOperation(c26064009.activate)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
        local g=Duel.SelectTarget(tp,Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
        Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
    else
        e:SetCategory(0)
        e:SetProperty(0)
        e:SetOperation(nil)
    end
end
function c26064009.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFacedown() then
        Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
    end
end
function c26064009.check(c,tp)
    return c and c:IsSetCard(0x664)
end
function c26064009.damcon(e,tp,eg,ep,ev,re,r,rp)
    return c26064009.check(Duel.GetAttacker(),tp) or c26064009.check(Duel.GetAttackTarget(),tp) and ev>Duel.GetLP(ep)
end
function c26064009.filter(c)
    return c:IsFaceup() and c:IsCode(26064007) and c:IsCanAddCounter(0xb6,1)
end
function c26064009.damop(e,tp,eg,ep,ev,re,r,rp)
    local val=ev
    local sval=0
    Duel.Recover(tp,val,REASON_EFFECT)
    while val>=100 do
        sval=sval+1
        val=val-100
    end
    local g=Duel.GetMatchingGroup(c26064009.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    if g:GetCount()>0 then
        Duel.BreakEffect()
        if g:GetCount()==1 then
            tg=Duel.GetFirstMatchingCard(c26064009.filter,tp,LOCATION_ONFIELD,0,nil)
            tg:AddCounter(0xb6,sval)
        else
            tg=g:Select(tp,1,1,nil)
            tg:GetFirst():AddCounter(0xb6,sval)
        end
        
    end
end
function c26064009.check2(c,tp)
    return c and c:IsType(TYPE_FLIP)
end
function c26064009.rdcon(e,tp,eg,ep,ev,re,r,rp)
    return c26064009.check2(Duel.GetAttacker(),tp) or c26064009.check2(Duel.GetAttackTarget(),tp)
end
function c26064009.rdop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(ep,ev/2)
end
function c26064009.flcheck(c,tp)
    return c and c:IsSetCard(0x664) and c:IsRelateToBattle()
end
function c26064009.flcon(e,tp,eg,ep,ev,re,r,rp)
    return c26064009.flcheck(Duel.GetAttacker(),tp)
end
function c26064009.flop(e,tp,eg,ep,ev,re,r,rp)
    local c=Duel.GetAttacker()
    if not c:IsPosition(POS_FACEDOWN_DEFENSE) then
        Duel.Hint(HINT_CARD,0,26064009)
        Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
    end
end