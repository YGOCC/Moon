--Chroma-Inversion Summoner Sage
function c249000421.initial_effect(c)
	--summon and set with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(62742651,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c249000421.ntcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)	
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c249000421.cost)
	e3:SetTarget(c249000421.target)
	e3:SetOperation(c249000421.operation)
	c:RegisterEffect(e3)
end
function c249000421.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil)
end
function c249000421.costfilter(c)
	return c:IsSetCard(0x1BC) and c:IsAbleToRemoveAsCost()
end
function c249000421.costfilter2(c,e)
	return c:IsSetCard(0x1BC) and not c:IsPublic()
end
function c249000421.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000421.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000421.costfilter2,tp,LOCATION_HAND,0,1,c)) end
	local option
	if Duel.IsExistingMatchingCard(c249000421.costfilter2,tp,LOCATION_HAND,0,1,nil,e)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000421.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000421.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000421.costfilter2,tp,LOCATION_HAND,0,1,c) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000421.costfilter2,tp,LOCATION_HAND,0,1,1,c)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000421.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000421.filter11(c,e,tp)
	local lv=c:GetOriginalLevel()
	return lv > 0 and c:IsType(TYPE_SYNCHRO) and (c:IsAbleToRemove() or c:IsLocation(LOCATION_MZONE))
		and Duel.IsExistingMatchingCard(c249000421.filter12,tp,LOCATION_EXTRA,0,1,nil,lv+1,c:GetAttribute(),e,tp)
end
function c249000421.filter12(c,rk,att,e,tp)
	return c:IsType(TYPE_XYZ) and c:GetRank() >=rk and c:GetRank()-4 <=rk and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c249000421.filter21(c,e,tp)
	return c:GetOriginalRank() >= 1 and Duel.IsExistingMatchingCard(c249000421.filter22,tp,LOCATION_EXTRA,0,1,nil,c:GetAttribute(),e,tp,c:GetOriginalRank()+1)
	and (c:IsAbleToRemove() or c:IsLocation(LOCATION_MZONE))
end
function c249000421.filter22(c,att,e,tp,lv)
	return c:IsType(TYPE_SYNCHRO) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
	and c:GetLevel() >=rk and c:GetLevel()-4
end
function c249000421.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and (chkc:IsLocation(LOCATION_GRAVE) or chkc:IsLocation(LOCATION_MZONE))
	and (c249000421.filter11(chkc,e,tp) or c249000421.filter21(chkc,e,tp)) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.IsExistingTarget(c249000421.filter11,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,e,tp)
		or Duel.IsExistingTarget(c249000421.filter21,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,e,tp)) end
	local option
	if Duel.IsExistingTarget(c249000421.filter11,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,e,tp) then option=0 end
	if Duel.IsExistingTarget(c249000421.filter21,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,e,tp) then option=1 end
	if Duel.IsExistingTarget(c249000421.filter11,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,e,tp)
	and Duel.IsExistingTarget(c249000421.filter21,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,e,tp) then
		option=Duel.SelectOption(tp,1073,1063)
	end
	if option==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,c249000421.filter11,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
		e:SetLabel(SUMMON_TYPE_XYZ)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,c249000421.filter21,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
		e:SetLabel(SUMMON_TYPE_SYNCHRO)
	end
end
function c249000421.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	if e:GetLabel()==SUMMON_TYPE_XYZ then
		if (tc:IsLocation(LOCATION_GRAVE) and Duel.Remove(tc,POS_FACEUP,REASON_COST)~=0) or (tc:IsLocation(LOCATION_MZONE) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c249000421.filter12,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetOriginalLevel()+2,tc:GetAttribute(),e,tp)
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
			local sg=Duel.SelectMatchingCard(tp,c249000421.filter22,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetAttribute(),e,tp,rk+2)
			if sg:GetCount()>0 then
				Duel.SpecialSummon(sg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
				sg:GetFirst():CompleteProcedure()
			end
		end
	end
end