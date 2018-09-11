--Snowgarde Guardian
function c93832691.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c93832691.sptg)
    e1:SetOperation(c93832691.spop)
    c:RegisterEffect(e1)
    --cannot be battle target
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(93832691,0))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(c93832691.atop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c93832691.atcon)
    c:RegisterEffect(e3)
    --Set
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(93832691,1))
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetTarget(c93832691.settg)
    e4:SetOperation(c93832691.setop)
    c:RegisterEffect(e4)
end
function c93832691.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,93832691,0x4d4,0x21,1900,600,4,RACE_WARRIOR,ATTRIBUTE_WATER) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c93832691.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,93832691,0x4d4,0x21,1900,600,4,RACE_WARRIOR,ATTRIBUTE_WATER) then
        c:AddMonsterAttribute(TYPE_EFFECT)
        Duel.SpecialSummonStep(c,1,tp,tp,true,false,POS_FACEUP)
        c:AddMonsterAttributeComplete()
        Duel.SpecialSummonComplete()
    end
end
function c93832691.cfilter(c,tp)
    
    return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsSetCard(0x4d4)
        and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c93832691.atcon(e,tp,eg,ep,ev,re,r,rp)
    return not eg:IsContains(e:GetHandler()) and eg:IsExists(c93832691.cfilter,1,nil,tp)
end
function c93832691.atop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e1:SetTargetRange(0,LOCATION_MZONE)
    e1:SetValue(c93832691.atlimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetTarget(c93832691.atlimit)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetValue(aux.tgoval)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function c93832691.atlimit(e,c)
    return c:IsFaceup() and c:IsSetCard(0x4d4)
end
function c93832691.setfilter(c)
    return c:IsSetCard(0x4d4) and not c:IsCode(93832691) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c93832691.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c93832691.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c93832691.setop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,c93832691.setfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SSet(tp,g:GetFirst())
        Duel.ConfirmCards(1-tp,g)
    end
end