--"Hacker - Loli, The Decodification's Queen"
local m=90072
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Link Materials"
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c90072.matfilter,2,2)
    --"Special Summon"
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(90072,0))
    e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e0:SetCode(EVENT_SUMMON_SUCCESS)
    e0:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e0:SetRange(LOCATION_MZONE)
    e0:SetCondition(c90072.spcon)
    e0:SetTarget(c90072.sptg)
    e0:SetOperation(c90072.spop)
    c:RegisterEffect(e0)
    --"Xyz Summon"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90072,1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,90072)
    e1:SetTarget(c90072.xyztg)
    e1:SetOperation(c90072.xyzop)
    c:RegisterEffect(e1)
    --"Special Summon 1 'Hacker - Pop, Code Specialist'"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90072,2))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCondition(c90072.matcon)
    e2:SetTarget(c90072.mattg)
    e2:SetOperation(c90072.matop)
    c:RegisterEffect(e2)
end
function c90072.matfilter(c,lc,sumtype,tp)
    return c:IsSetCard(0x1aa) and c:IsType(TYPE_NORMAL)
end
function c90072.cfilter(c,lg)
    return lg:IsContains(c)
end
function c90072.spcon(e,tp,eg,ep,ev,re,r,rp)
    local lg=e:GetHandler():GetLinkedGroup()
    return eg:IsExists(c90072.cfilter,1,nil,lg)
end
function c90072.filter(c,e,tp)
    return c:IsSetCard(0x1aa) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c90072.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c90072.filter(chkc,e,tp) end
    if chk==0 then return Duel.IsExistingTarget(c90072.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c90072.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c90072.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then end
    Duel.SpecialSummonComplete()
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,0)
    e2:SetTarget(c90072.splimit)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function c90072.splimit(e,c)
    return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
function c90072.xyzfilter(c)
    return c:IsSetCard(0x1aa) and c:IsXyzSummonable(nil)
end
function c90072.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c90072.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c90072.xyzop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c90072.xyzfilter,tp,LOCATION_EXTRA,0,nil)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=g:Select(tp,1,1,nil)
        Duel.XyzSummon(tp,tg:GetFirst(),nil)
    end
end
function c90072.matcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DESTROY)
end
function c90072.matfilter1(c,e,tp)
    return c:IsCode(90071) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90072.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c90072.matfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c90072.matop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c90072.matfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end