--coded by Lyris
--Steelus Tempestatem Ultima
function c192051212.initial_effect(c)
	c:EnableReviveLimit()
	--When this card is Ritual Summoned: You can Special Summon 1 "Steelus" monster from your GY, but it has its effects negated, then send up to 3 "Steelus" monsters from your Deck to the GY.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetCondition(c192051212.spcon)
	e1:SetTarget(c192051212.sptg)
	e1:SetOperation(c192051212.spop)
	c:RegisterEffect(e1)
end
function c192051212.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c192051212.spfilter(c,e,tp)
	return c:IsSetCard(0x617) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c192051212.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x617) and c:IsAbleToGrave()
end
function c192051212.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c192051212.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c192051212.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c192051212.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c192051212.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
		local sg=Duel.GetMatchingGroup(c192051212.tgfilter,tp,LOCATION_DECK,0,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tg=sg:Select(tp,1,3,nil)
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
	end
end
