--Global Space Bridge
function c115000012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,115000012+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c115000012.condition)
	e1:SetTarget(c115000012.target)
	e1:SetOperation(c115000012.activate)
	c:RegisterEffect(e1)
end
function c115000012.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c115000012.filter(c,e,tp)
	return c:IsSetCard(0x201) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c115000012.filter2,tp,0,LOCATION_MZONE,1,nil)) or c:IsLevelBelow(4)
end
function c115000012.filter2(c)
	return c:IsLevelAbove(5) or c:GetRank() > 4 or c:GetLink() > 2
end
function c115000012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c115000012.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c115000012.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c115000012.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
