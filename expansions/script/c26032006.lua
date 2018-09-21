function c26032006.initial_effect(c)
    c:SetSPSummonOnce(26032006)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
    c:EnableReviveLimit()
    --on summon eff
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(26032006,0))
    e1:SetCategory(CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(c26032006.sumtg)
    e1:SetOperation(c26032006.sumop)
    c:RegisterEffect(e1)
    --quick field play
    local e2=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(26032006,1))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,26032006+EFFECT_COUNT_CODE_OATH)
    e2:SetTarget(c26032006.ftg)
    e2:SetOperation(c26032006.fop)
    c:RegisterEffect(e2)
    --revive
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(26032006,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,TIMING_BATTLE_STEP_END)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCondition(c26032006.spcon)
    e3:SetTarget(c26032006.sptg)
    e3:SetOperation(c26032006.spop)
    c:RegisterEffect(e3)
end
function c26032006.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(800)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c26032006.sumop(e,tp,eg,ep,ev,re,r,rp,chk)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
function c26032006.ffilter(c,tp)
    return c:IsCode(26032010) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c26032006.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c26032006.ffilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c26032006.fop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstMatchingCard(c26032006.ffilter,tp,LOCATION_DECK,0,nil,tp)
    if tc then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local te=tc:GetActivateEffect()
        te:UseCountLimit(tp,1,true)
        local tep=tc:GetControler()
        local cost=te:GetCost()
        if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
        Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
    end
end
--revival
function c26032006.cfilter(c,tp)
    return c:IsCode(26032010) and c:IsFaceup()
end
function c26032006.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c26032006.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp)
        and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c26032006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26032006.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
    end
end