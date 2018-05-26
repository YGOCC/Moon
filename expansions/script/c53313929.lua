--Mysterious Rising
function c53313929.initial_effect(c)
	--Tribute 1 "Mysterious" monster on the field; Special Summon 1 level 6 or lower "Mysterious" Pandemonium Monster from your GY or that is Banished. You can only activate 1 "Mysterious Rising" per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,53313929+EFFECT_COUNT_CODE_OATH)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCost(c53313929.cost)
	e1:SetTarget(c53313929.target)
	e1:SetOperation(c53313929.activate)
	c:RegisterEffect(e1)
end
function c53313929.cfilter(c)
	return c:IsSetCard(0xcf6) and c:IsReleasable()
end
function c53313929.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53313929.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c53313929.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c53313929.filter(c,e,tp)
	return c:IsLevelBelow(6) and c:IsSetCard(0xcf6)
		and c:IsType(TYPE_PANDEMONIUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c53313929.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c53313929.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c53313929.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c53313929.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
