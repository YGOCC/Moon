--Rank-Up-Magic Lyris Force II
function c240100046.initial_effect(c)
	--Target 1 "Blitzkrieg" Xyz Monster in your GY; Special Summon it, then Special Summon 1 LIGHT Dragon or Machine Xyz Monster from your Extra Deck with 2 Ranks higher using it as the Xyz Material. (This is treated as an Xyz Summon.)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c240100046.target)
	e2:SetOperation(c240100046.activate)
	c:RegisterEffect(e2)
end
function c240100046.filter1(c,e,tp)
	return c:IsSetCard(0x7c4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c240100046.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+2)
end
function c240100046.filter2(c,e,tp,mc,rk)
	return c:GetRank()==rk and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_DRAGON+RACE_MACHINE) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c240100046.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c240100046.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingTarget(c240100046.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c240100046.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,tp,LOCATION_EXTRA)
end
function c240100046.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetLocationCountFromEx(tp)<=0 then return end
	local tc1=Duel.GetFirstTarget()
	local rk=tc1:GetRank()+2
	local g1=Group.FromCards(tc1)
	if tc1 and Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c240100046.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc1,rk)
		local tc2=g2:GetFirst()
		if tc2 then
			Duel.BreakEffect()
			tc2:SetMaterial(g1)
			Duel.Overlay(tc2,g1)
			Duel.SpecialSummon(tc2,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			tc2:CompleteProcedure()
		end
	end
end
