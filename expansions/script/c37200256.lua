--Magical Present
--Script by XGlitchy30
function c37200256.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c37200256.target)
	e1:SetOperation(c37200256.activate)
	c:RegisterEffect(e1)
end
--filters
function c37200256.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:GetLevel()>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
--Activate
function c37200256.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and Duel.IsExistingMatchingCard(c37200256.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c37200256.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c37200256.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP)
		local op=Duel.GetOperatedGroup()
		local sp=op:GetFirst()
		Duel.BreakEffect()
		--banish
		local lv=sp:GetLevel()
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
		if lv>ct then return end
		if lv==0 then return end
		local rem=Duel.GetDecktopGroup(1-tp,lv)
		Duel.DisableShuffleCheck()
		Duel.Remove(rem,POS_FACEDOWN,REASON_EFFECT)
	end
end