--Numeral-Mage Silver Caller
function c249000403.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(249000403,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,249000403)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c249000403.condition)
	e1:SetCost(c249000403.cost)	
	e1:SetTarget(c249000403.target)
	e1:SetOperation(c249000403.operation)
	c:RegisterEffect(e1)
end
function c249000403.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_EXTRA,0,nil,0x48)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>3
end
function c249000403.costfilter(c)
	return c:IsSetCard(0x1B9) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c249000403.costfilter2(c,e)
	return c:IsSetCard(0x1B9) and c:IsType(TYPE_MONSTER) and not c:IsPublic() and c~=e:GetHandler()
end
function c249000403.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000400.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000403.costfilter2,tp,LOCATION_HAND,0,1,nil,e)) end
	local option
	if Duel.IsExistingMatchingCard(c249000403.costfilter2,tp,LOCATION_HAND,0,1,nil,e)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000403.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000403.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000403.costfilter2,tp,LOCATION_HAND,0,1,nil,e) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000403.costfilter2,tp,LOCATION_HAND,0,1,1,nil,e)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000403.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000403.tgfilter(c,e,tp)
	return c:IsSetCard(0x48) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false)
end
function c249000403.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000403.tgfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000403.numtablematch(num)
	for i=1,25 do
		if c249000403.missing_number_table[i]==num then return true end
	end
	return false
end
function c249000403.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then
		local g=Duel.GetDecktopGroup(tp,1)
		local tc=g:GetFirst()
		math.randomseed( tc:getcode() )
	end
	local num=math.random(0,107)
	while c249000403.numtablematch(num) do num=math.random(0,107) end
	local a1=Duel.AnnounceNumber(tp,num)
	local ac=Duel.AnnounceCard(tp)
	local token=Duel.CreateToken(tp,ac)
	while not (token.xyz_number==a1)
		do
			ac=Duel.AnnounceCard(tp)
			token=Duel.CreateToken(tp,ac)
		end
--	Duel.Remove(token,POS_FACEDOWN,REASON_RULE)
	Duel.SendtoDeck(token,nil,0,REASON_RULE)
	num=math.random(0,107)
	while c249000403.numtablematch(num) do num=math.random(0,107) end
	a1=Duel.AnnounceNumber(tp,num)
	ac=Duel.AnnounceCard(tp)
	token=Duel.CreateToken(tp,ac)
	while not (token.xyz_number==a1)
		do
			ac=Duel.AnnounceCard(tp)
			token=Duel.CreateToken(tp,ac)
		end
--	Duel.Remove(token,POS_FACEDOWN,REASON_RULE)
	Duel.SendtoDeck(token,nil,0,REASON_RULE)
	local xyzg=Duel.GetMatchingGroup(c249000403.tgfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:RandomSelect(tp,1):GetFirst()	
		if Duel.SpecialSummonStep(xyz,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) then
			local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
			if tc2 then
				Duel.Overlay(xyz,tc2)
			end
			tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
			if tc2 then
				Duel.Overlay(xyz,tc2)
			end
			Duel.SpecialSummonComplete()
			xyz:CompleteProcedure()					
		end
	end			
end
c249000403.missing_number_table={
1,2,3,4,24,26,27,28,29,41,45,51,59,60,68,70,71,75,76,78,89,90,97,98,100
}