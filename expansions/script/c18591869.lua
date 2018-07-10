--Ninja Defender
--fixed by Márcio Eduine
function c18591869.initial_effect(c)
	--link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_WARRIOR),3)
    c:EnableReviveLimit()
    --cannot link material
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e1:SetCondition(c18591869.matcon)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
    e2:SetRange(LOCATION_MZONE)
    c:RegisterEffect(e2)
    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_DAMAGE)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c18591869.spcon)
    e3:SetTarget(c18591869.sptg)
    e3:SetOperation(c18591869.spop)
    c:RegisterEffect(e3)
end
function c18591869.matfilter(c)
	return c:IsLinkRace(RACE_WARRIOR)
end
function c18591869.matcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetTurnID()==Duel.GetTurnCount()
end
function c18591869.spcon(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp and r&REASON_BATTLE+REASON_EFFECT~=0
end
function c18591869.filter(c,e,tp,zone)
    return c:IsSetCard(0x2b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c18591869.lkfilter(c)
    return c:IsSetCard(0x2b) and c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c18591869.zonefilter(tp)
    local lg=Duel.GetMatchingGroup(c18591869.lkfilter,tp,LOCATION_MZONE,0,nil)
    local zone=0
    lg:ForEach(function(tc)
        zone=zone|tc:GetLinkedZone()
    end)
    return zone
end
function c18591869.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local zone=c18591869.zonefilter(tp)
    if chk==0 then
        local zone=c18591869.zonefilter(tp)
        return zone~=0 and Duel.IsExistingMatchingCard(c18591869.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c18591869.spop(e,tp,eg,ep,ev,re,r,rp)
    local zone=c18591869.zonefilter(tp)
    if Duel.GetLocationCountFromEx(tp)<=0 and zone~=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c18591869.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,zone)
    if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)>0 then
        Duel.Recover(tp,ev,REASON_EFFECT)
    end
end