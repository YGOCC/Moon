--Chaos Evolution
function c249000907.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c249000907.target)
	e1:SetOperation(c249000907.activate)
	c:RegisterEffect(e1)
	--xyz material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19310321,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c249000907.target2)
	e2:SetOperation(c249000907.operation2)
	c:RegisterEffect(e2)
	--code
--	local e3=Effect.CreateEffect(c)
--	e3:SetType(EFFECT_TYPE_SINGLE)
--	e3:SetCode(EFFECT_ADD_SETCODE)
--	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
--	e3:SetRange(LOCATION_GRAVE+LOCATION_ONFIELD)
--	e3:SetValue(0x95)
--	c:RegisterEffect(e3)
end
function c249000907.tfilter(c,e,tp,code,lvrk)
	if c:GetOriginalCode()==6165656 and code~=48995978 then return false end
	if not ((c:GetLevel() -1 == lvrk) or (c:GetLevel() -2 == lvrk) or (c:GetRank() -1 == lvrk) or (c:GetRank() -2 == lvrk)) then return false end
	return (c:IsSetCard(0xcf) or c:IsSetCard(0x1048) or c:IsSetCard(0x1073)) and c:IsType(TYPE_MONSTER)
	 and ((c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsSetCard(0x10cf)) or (c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsType(TYPE_XYZ))
	 or (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsType(TYPE_XYZ)))
end
function c249000907.filter(c,e,tp)
	local lvrk
	if c:GetRank() > 0 then lvrk=c:GetRank() else lvrk=c:GetLevel() end
	return lvrk > 0 and c:IsFaceup() and (c:IsSetCard(0xcf) or c:IsSetCard(0x48) or c:IsSetCard(0x1073)) and c:IsType(TYPE_MONSTER) and
		((Duel.IsExistingMatchingCard(c249000907.tfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode(),lvrk) and Duel.GetLocationCountFromEx(tp,tp,c)>0)
		or Duel.IsExistingMatchingCard(c249000907.tfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode(),lvrk)) 
end
function c249000907.chkfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0xcf) or c:IsSetCard(0x1048) or c:IsSetCard(0x1073))
end
function c249000907.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c249000907.chkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000907.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c249000907.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK)
end
function c249000907.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local lvrk
	if tc:GetRank() > 0 then lvrk=tc:GetRank() else lvrk=tc:GetLevel() end
	if lvrk < 1 then return end
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	if Duel.GetLocationCountFromEx(tp)<=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c249000907.tfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode(),lvrk)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			local sc=sg:GetFirst()
			if sc:IsSetCard(0x10cf) then Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP) else Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) end
			sg:GetFirst():CompleteProcedure()
		end
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and Duel.GetLocationCountFromEx(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c249000907.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetCode(),lvrk)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			local sc=sg:GetFirst()
			if sc:IsSetCard(0x10cf) then
				Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
			elseif sc:IsType(TYPE_XYZ) then
				Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
			sg:GetFirst():CompleteProcedure()
		end
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCountFromEx(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c249000907.tfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode(),lvrk)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			local sc=sg:GetFirst()
			if sc:IsSetCard(0x10cf) then
				Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
			elseif sc:IsType(TYPE_XYZ) then
				Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
			sg:GetFirst():CompleteProcedure()
		end	
	end
end
function c249000907.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c249000907.filter2(c)
	return c:IsType(TYPE_XYZ)
end
function c249000907.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c249000907.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c249000907.filter2,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19310321,1))
	local g1=Duel.SelectTarget(tp,c249000907.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19310321,2))
	local g2=Duel.SelectTarget(tp,c249000907.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g2,1,0,0)
end
function c249000907.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,tc,e)
	if g:GetCount()>0 then
		Duel.Overlay(tc,g)
	end
end