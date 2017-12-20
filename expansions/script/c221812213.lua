--Backdoor
function c221812213.initial_effect(c)
	--Banish 3 "Viravolve" monsters from your GY: Special Summon 1 "Viravolve" monster from your GY.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCost(c221812213.cost)
	e1:SetTarget(c221812213.target)
	e1:SetOperation(c221812213.activate)
	c:RegisterEffect(e1)
end
function c221812213.cfilter(c)
	return c:IsSetCard(0xa67) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c221812213.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c221812213.cfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c221812213.spfilter(c,e,tp,chk)
	return c:IsSetCard(0xa67) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not chk or (chk==0 and Duel.IsExistingMatchingCard(c221812213.cfilter,tp,LOCATION_GRAVE,0,3,c)))
end
function c221812213.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c221812213.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,chk) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c221812213.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c221812213.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
