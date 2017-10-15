--Arcane-Rank-Up-Magic Counter Force
function c249000628.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCost(c249000628.condition)
	e1:SetCost(c249000628.cost)
	e1:SetTarget(c249000628.target)
	e1:SetOperation(c249000628.activate)
	c:RegisterEffect(e1)
end
function c249000628.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c249000628.costfilter(c)
	return c:IsSetCard(0x1E0) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c249000628.costfilter2(c,e)
	return c:IsSetCard(0x1E0) and c:IsType(TYPE_MONSTER) and not c:IsPublic() and c~=e:GetHandler()
end
function c249000628.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000628.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000628.costfilter2,tp,LOCATION_HAND,0,1,nil,e)) end
	local option
	if Duel.IsExistingMatchingCard(c249000628.costfilter2,tp,LOCATION_HAND,0,1,nil,e)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000628.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000628.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000628.costfilter2,tp,LOCATION_HAND,0,1,nil,e) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000628.costfilter2,tp,LOCATION_HAND,0,1,1,nil,e)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000628.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000628.filter1(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsFaceup() 
		and Duel.IsExistingMatchingCard(c249000628.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+1,c:GetCode(),c:GetAttribute())
end
function c249000628.filter2(c,e,tp,mc,rk,code,att)
	if c.rum_limit_code and code~=c.rum_limit_code then return false end
	return c:GetRank()==rk and mc:IsCanBeXyzMaterial(c) and c:IsAttribute(att)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c249000628.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c249000628.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c249000628.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c249000628.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000628.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c249000628.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1,tc:GetCode())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP_ATTACK)
		sc:CompleteProcedure()
	end
end
