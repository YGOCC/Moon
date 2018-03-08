function c192051218.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x617),3,3)
	aux.AddXyzProcedureLevelFree(c,c192051218.mfilter,c192051218.xyzcheck,2,2)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(192051218,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c192051218.spcost)
	e1:SetOperation(c192051218.spop)
	c:RegisterEffect(e1)
end
function c192051218.mfilter(c,xyzc)
	return c:IsSetCard(0x617) and (c:GetLevel()==3 or c:IsCode(192051210))
end
function c192051218.xyzcheck(g)
	return g:IsExists(Card.IsCode,1,nil,192051210)
end
function c192051218.spfilter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:GetLevel()==3 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c192051218.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
		and Duel.IsExistingMatchingCard(c192051218.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c192051218.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c192051218.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false)
	end
end
