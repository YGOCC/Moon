--32083025
function c32083025.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCost(c32083025.cost)
	e1:SetTarget(c32083025.target)
	e1:SetOperation(c32083025.activate)
	c:RegisterEffect(e1)
end
function c32083025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c32083025.filter(c,e,tp)
return c:IsRace(RACE_DRAGON) and c:IsLevelBelow(4)
and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32083025.target(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
and Duel.IsExistingMatchingCard(c32083025.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c32083025.activate(e,tp,eg,ep,ev,re,r,rp)
if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
local g=Duel.SelectMatchingCard(tp,c32083025.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
if g:GetCount()>0 then
Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
end
