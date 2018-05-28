--Fantasia Knight Traitor
function c71473127.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x1c1d),2,2)
     --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(71473127,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c71473127.sptg)
    e1:SetOperation(c71473127.spop)
    c:RegisterEffect(e1)
    --battle indestructable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetTarget(c71473127.indtg)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c71473127.spcon)
    e3:SetTarget(c71473127.sptg1)
    e3:SetOperation(c71473127.spop1)
    c:RegisterEffect(e3)
end
function c71473127.filter(c,e,tp,zone)
    return c:IsSetCard(0x1c1d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c71473127.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
      if chk==0 then
        local zone=e:GetHandler():GetLinkedZone()
        return zone~=0 and Duel.IsExistingMatchingCard(c71473127.filter,tp,LOCATION_PZONE,0,1,nil,e,tp,zone)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function c71473127.spop(e,tp,eg,ep,ev,re,r,rp)
local zone=e:GetHandler():GetLinkedZone()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if zone==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c71473127.filter,tp,LOCATION_PZONE,0,1,1,nil,e,tp,zone)
    local tc=g:GetFirst()
    if not tc then return end
    if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)~=0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCountLimit(1)
        e1:SetOperation(c71473127.desop)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
    end
end
function c71473127.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c71473127.indtg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0x1c1d)
end
function c71473127.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c71473127.spfilter(c,e,tp)
    return c:IsSetCard(0x1c1d) and c:IsType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71473127.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    local loc=0
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
    if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
    if chk==0 then return loc~=0 and Duel.IsExistingMatchingCard(c71473127.spfilter,tp,loc,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function c71473127.spop1(e,tp,eg,ep,ev,re,r,rp)
    local loc=0
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
    if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
    if loc==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71473127.spfilter),tp,loc,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end