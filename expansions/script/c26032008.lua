function c26032008.initial_effect(c)
    c:SetSPSummonOnce(26032008)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
    c:EnableReviveLimit()
    --on summon eff
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(26032008,0))
    e1:SetCategory(CATEGORY_POSITION)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(c26032008.sumtg)
    e1:SetOperation(c26032008.sumop)
    c:RegisterEffect(e1)
    --quick field play
    local e2=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(26032008,1))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,26032008+EFFECT_COUNT_CODE_OATH)
    e2:SetTarget(c26032008.ftg)
    e2:SetOperation(c26032008.fop)
    c:RegisterEffect(e2)
    --revive
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(26032008,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,TIMING_BATTLE_STEP_END)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCondition(c26032008.spcon)
    e3:SetTarget(c26032008.sptg)
    e3:SetOperation(c26032008.spop)
    c:RegisterEffect(e3)
end
function c26032008.filter(c)
    return c:IsFaceup() and c:IsCanTurnSet()
end
function c26032008.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(c26032008.filter,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c26032008.sumop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c26032008.filter,tp,0,LOCATION_MZONE,nil)
    Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end
function c26032008.ffilter(c,tp)
    return c:IsCode(26032012) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c26032008.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c26032008.ffilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c26032008.fop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstMatchingCard(c26032008.ffilter,tp,LOCATION_DECK,0,nil,tp)
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
function c26032008.cfilter(c,tp)
    return c:IsCode(26032012) and c:IsFaceup()
end
function c26032008.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c26032008.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp)
        and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c26032008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26032008.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
    end
end