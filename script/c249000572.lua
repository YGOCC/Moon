---Auium Xyz Summoner
function c249000572.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,249000572)
	e1:SetCondition(c249000572.condition)
	e1:SetCost(c249000572.cost)
	e1:SetTarget(c249000572.target)
	e1:SetOperation(c249000572.operation)
	c:RegisterEffect(e1)
end
function c249000572.confilter(c)
	return c:IsSetCard(0x1D1) and c:GetCode()~=249000572 and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000572.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000572.confilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil)
end
function c249000572.costfilter(c)
	return c:IsSetCard(0x1D1) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c249000572.costfilter2(c,e)
	return c:IsSetCard(0x1D1) and not c:IsPublic() and c~=e:GetHandler()
end
function c249000572.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000572.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000572.costfilter2,tp,LOCATION_HAND,0,1,nil,e)) end
	local option
	if Duel.IsExistingMatchingCard(c249000572.costfilter2,tp,LOCATION_HAND,0,1,nil,e)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000572.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000572.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000572.costfilter2,tp,LOCATION_HAND,0,1,nil,e) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000572.costfilter2,tp,LOCATION_HAND,0,1,1,nil,e)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000572.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000572.filter1(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and lv<=10 and Duel.IsExistingMatchingCard(c249000572.filter2,tp,LOCATION_EXTRA,0,1,nil,lv,e,tp,c)
end
function c249000572.filter2(c,lv,e,tp,c2)
	return c:GetRank()==lv  and c2:IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c249000572.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c249000572.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000572.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c249000572.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc then
		local g2=Duel.SelectMatchingCard(tp,c249000572.filter2,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetLevel(),e,tp,tc)
		local sc=g2:GetFirst()
		if sc then
			local ovg=Group.FromCards(c)
			ovg:AddCard(tc)
			sc:SetMaterial(ovg)
			Duel.Overlay(sc,ovg)
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(c249000572.ftarget)
			e1:SetLabel(sc:GetFieldID())
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c249000572.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end