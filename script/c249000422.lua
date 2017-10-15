--Rank-Up-Magic Chroma-Inversion Force
function c249000422.initial_effect(c)	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c249000422.cost)
	e1:SetTarget(c249000422.target)
	e1:SetOperation(c249000422.activate)
	c:RegisterEffect(e1)
end
function c249000422.costfilter(c)
	return c:IsSetCard(0x1BC) and c:IsAbleToRemoveAsCost()
end
function c249000422.costfilter2(c,e)
	return c:IsSetCard(0x1BC) and not c:IsPublic() and c~=e:GetHandler()
end
function c249000422.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000422.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000422.costfilter2,tp,LOCATION_HAND,0,1,nil,e)) end
	local option
	if Duel.IsExistingMatchingCard(c249000422.costfilter2,tp,LOCATION_HAND,0,1,nil,e)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000422.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000422.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000422.costfilter2,tp,LOCATION_HAND,0,1,nil,e) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000422.costfilter2,tp,LOCATION_HAND,0,1,1,nil,e)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000422.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000422.filter11(c,e,tp)
	local lv=c:GetOriginalLevel()
	return lv > 0 and c:IsType(TYPE_SYNCHRO) and (c:IsAbleToRemove() or c:IsLocation(LOCATION_MZONE))
		and Duel.IsExistingMatchingCard(c249000422.filter12,tp,LOCATION_EXTRA,0,1,nil,lv+1,c:GetAttribute(),e,tp)
end
function c249000422.filter12(c,rk,att,e,tp)
	return c:IsType(TYPE_XYZ) and c:GetRank() >=rk and c:GetRank()-4 <=rk and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c249000422.filter21(c,e,tp)
	return c:GetOriginalRank() >= 1 and Duel.IsExistingMatchingCard(c249000422.filter22,tp,LOCATION_EXTRA,0,1,nil,c:GetAttribute(),e,tp,c:GetOriginalRank()+1)
	and (c:IsAbleToRemove() or c:IsLocation(LOCATION_MZONE))
end
function c249000422.filter22(c,att,e,tp,lv)
	return c:IsType(TYPE_SYNCHRO) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
	and c:GetLevel() >=rk and c:GetLevel()-4
end
function c249000422.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and (chkc:IsLocation(LOCATION_GRAVE) or chkc:IsLocation(LOCATION_MZONE))
	and (c249000422.filter11(chkc,e,tp) or c249000422.filter21(chkc,e,tp)) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.IsExistingTarget(c249000422.filter11,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,e,tp)
		or Duel.IsExistingTarget(c249000422.filter21,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,e,tp)) end
	local option
	if Duel.IsExistingTarget(c249000422.filter11,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,e,tp) then option=0 end
	if Duel.IsExistingTarget(c249000422.filter21,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,e,tp) then option=1 end
	if Duel.IsExistingTarget(c249000422.filter11,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,e,tp)
	and Duel.IsExistingTarget(c249000422.filter21,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,e,tp) then
		option=Duel.SelectOption(tp,1073,1063)
	end
	if option==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,c249000422.filter11,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
		e:SetLabel(SUMMON_TYPE_XYZ)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,c249000422.filter21,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
		e:SetLabel(SUMMON_TYPE_SYNCHRO)
	end
end
function c249000422.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	if e:GetLabel()==SUMMON_TYPE_XYZ then
		if (tc:IsLocation(LOCATION_GRAVE) and Duel.Remove(tc,POS_FACEUP,REASON_COST)~=0) or (tc:IsLocation(LOCATION_MZONE) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c249000422.filter12,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetOriginalLevel()+2,tc:GetAttribute(),e,tp)
			local sc=g:GetFirst()
			if sc then
				Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
				sc:CompleteProcedure()
				local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
				if tc2 then
					Duel.Overlay(sc,tc2)
				end
					tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
				if tc2 then
					Duel.Overlay(sc,tc2)
				end
			end
		end
	end
	if e:GetLabel()==SUMMON_TYPE_SYNCHRO then
		if (tc:IsLocation(LOCATION_GRAVE) and Duel.Remove(tc,POS_FACEUP,REASON_COST)~=0) or (tc:IsLocation(LOCATION_MZONE) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0) then
			local rk=tc:GetOriginalRank()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c249000422.filter22,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetAttribute(),e,tp,rk+2)
			if sg:GetCount()>0 then
				Duel.SpecialSummon(sg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
				sg:GetFirst():CompleteProcedure()
			end
		end
	end
end