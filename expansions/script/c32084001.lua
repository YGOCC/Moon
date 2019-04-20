--Orichalcos Deuteros
function c32084001.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_RECOVER)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1) 
    e2:SetDescription(aux.Stringid(32084001,0))
    e2:SetTarget(c32084001.target)
    e2:SetOperation(c32084001.operation)
    c:RegisterEffect(e2)
    --DESTROY
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_SZONE)
    e3:SetDescription(aux.Stringid(32084001,1))
    e3:SetCondition(c32084001.atkcon)
    e3:SetCost(c32084001.cost)
    e3:SetTarget(c32084001.atktg)
    e3:SetOperation(c32084001.atkop)
    c:RegisterEffect(e3)
    --selfdes
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_ADJUST)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCondition(c32084001.sdcon2)
    e4:SetOperation(c32084001.sdop)
    c:RegisterEffect(e4)
end
function c32084001.cdfilter(c,ft,tp)
    return c:IsFaceup() and c:IsCode(32084000)
end
function c32084001.acost(e,tp,eg,ep,ev,re,r,rp,chk)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return ft>-1 and Duel.CheckReleaseGroupCost(tp,c32084001.cdfilter,1,false,nil,nil,ft,tp) end
    local g=Duel.SelectReleaseGroupCost(tp,c32084001.cdfilter,1,1,false,nil,nil,ft,tp)
    Duel.Release(g,REASON_COST)
end
function c32084001.cfilter(c)
    return c:IsFaceup() and c:IsCode(32084000)
end
function c32084001.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c32084001.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c32084001.sdcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(32084001)==0
end
function c32084001.sdop(e,tp,eg,ep,ev,re,r,rp)  
    e:GetHandler():CopyEffect(32084000,RESET_EVENT+0x1fe0000)
    e:GetHandler():RegisterFlagEffect(32084001,RESET_EVENT+0x1fe0000,0,1)
end
function c32084001.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 end
    Duel.SetTargetPlayer(tp)
    local rec=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)*500
    Duel.SetTargetParam(rec)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c32084001.operation(e,tp,eg,ep,ev,re,r,rp)
    local rec=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)*500
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    Duel.Recover(p,rec,REASON_EFFECT)
end
function c32084001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
    local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
    Duel.Release(g,REASON_COST)
end
function c32084001.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end
function c32084001.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tg=Duel.GetAttacker()
    if chkc then return chkc==tg end
    if chk==0 then return tg:IsOnField() and tg:IsDestructable() and tg:IsCanBeEffectTarget(e) end
    Duel.SetTargetCard(tg)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c32084001.atkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetAttacker()
    if tc:IsRelateToEffect(e) and tc:IsAttackable() and Duel.NegateAttack() then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end