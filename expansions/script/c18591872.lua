--Kid Ninja - The Synchronizer
function c18591872.initial_effect(c)
--synchro effect
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(18591872,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c18591872.sccon)
    e2:SetTarget(c18591872.sctarg)
    e2:SetOperation(c18591872.scop)
    c:RegisterEffect(e2)
end
function c18591872.drcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c18591872.sccon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
        and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c18591872.sctarg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(18591872)==0
        and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,c) end
    c:RegisterFlagEffect(18591872,RESET_CHAIN,0,1)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c18591872.scop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,1,1,nil)
        Duel.SynchroSummon(tp,sg:GetFirst(),c)
    end
end
