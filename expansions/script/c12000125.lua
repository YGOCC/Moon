--Teutonic Knight - Umbrasweeper
function c12000125.initial_effect(c)
--Special Summon
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12000125,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,12000125)
	e1:SetCondition(c12000125.spcon)
	e1:SetCost(c12000125.spcost)
	e1:SetTarget(c12000125.sptg)
	e1:SetOperation(c12000125.spop)
	c:RegisterEffect(e1)
--Link Summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(12000125,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,12000225)
    e2:SetCondition(c12000125.rmcon)
    e2:SetTarget(c12000125.linktg)
    e2:SetOperation(c12000125.linkop)
    c:RegisterEffect(e2)
end
--Special Summon from hand
function c12000125.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c12000125.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c12000125.spfilter1(c,e,tp)
	return c:IsSetCard(0x857) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12000125.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c12000125.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c12000125.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c12000125.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
--Link Summon
function c12000125.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return re and re:IsActiveType(TYPE_MONSTER) and (re:GetHandler():IsSetCard(0x857) or re:GetHandler():IsSetCard(0x858)) and not re:GetHandler():IsCode(12000125)
end
function c12000125.linkfilter(c)
    return c:IsSpecialSummonable(SUMMON_TYPE_LINK) and c:IsSetCard(0x857)
end
function c12000125.linktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c12000125.linkfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c12000125.linkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
    local g=Duel.SelectMatchingCard(tp,c12000125.linkfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_LINK,c)   
    end
end