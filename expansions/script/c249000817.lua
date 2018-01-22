--Elemental Magic Summoning Art
function c249000817.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,249000817+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c249000817.condition)
	e1:SetCost(c249000817.cost)
	e1:SetTarget(c249000817.target)
	e1:SetOperation(c249000817.activate)
	c:RegisterEffect(e1)
end
function c249000817.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1F3) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000817.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c249000817.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>1 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE,nil)
end
function c249000817.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetLP(tp)< 3000 then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	else
		Duel.PayLPCost(tp,1500)
	end
end
function c249000817.filter(c,e,tp,lvrk,att)
	return (c:IsType(TYPE_SYNCHRO) and c:GetLevel()>=4 and c:GetLevel()<=lvrk and c:IsAttribute(att)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false))
		or (c:IsType(TYPE_XYZ) and c:GetRank()>=4 and c:GetRank()<=lvrk and c:IsAttribute(att)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false))
end
function c249000817.attfilter(c,att)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAttribute(att)
end
function c249000817.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=0 
	if Duel.IsExistingMatchingCard(c249000817.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_EARTH) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c249000817.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_WATER) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c249000817.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_FIRE) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c249000817.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_WIND) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c249000817.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_LIGHT) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c249000817.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_DARK) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c249000817.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_DEVINE) then ct=ct+1 end
	local att=0
	if Duel.IsExistingMatchingCard(c249000815.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_EARTH) then att=att+ATTRIBUTE_EARTH end
	if Duel.IsExistingMatchingCard(c249000815.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_WATER) then att=att+ATTRIBUTE_WATER end
	if Duel.IsExistingMatchingCard(c249000815.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_FIRE) then att=att+ATTRIBUTE_FIRE end
	if Duel.IsExistingMatchingCard(c249000815.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_WIND) then att=att+ATTRIBUTE_WIND end
	if Duel.IsExistingMatchingCard(c249000815.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_LIGHT) then att=att+ATTRIBUTE_LIGHT end
	if Duel.IsExistingMatchingCard(c249000815.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_DARK) then att=att+ATTRIBUTE_DARK end
	if Duel.IsExistingMatchingCard(c249000815.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_DEVINE) then att=att+ATTRIBUTE_DEVINE end
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 and att>0
		and Duel.IsExistingMatchingCard(c249000817.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,ct+3,att) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000817.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=0 
	if Duel.IsExistingMatchingCard(c249000817.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_EARTH) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c249000817.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_WATER) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c249000817.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_FIRE) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c249000817.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_WIND) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c249000817.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_LIGHT) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c249000817.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_DARK) then ct=ct+1 end
	if Duel.IsExistingMatchingCard(c249000817.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_DEVINE) then ct=ct+1 end
	local att=0
	if Duel.IsExistingMatchingCard(c249000815.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_EARTH) then att=att+ATTRIBUTE_EARTH end
	if Duel.IsExistingMatchingCard(c249000815.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_WATER) then att=att+ATTRIBUTE_WATER end
	if Duel.IsExistingMatchingCard(c249000815.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_FIRE) then att=att+ATTRIBUTE_FIRE end
	if Duel.IsExistingMatchingCard(c249000815.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_WIND) then att=att+ATTRIBUTE_WIND end
	if Duel.IsExistingMatchingCard(c249000815.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_LIGHT) then att=att+ATTRIBUTE_LIGHT end
	if Duel.IsExistingMatchingCard(c249000815.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_DARK) then att=att+ATTRIBUTE_DARK end
	if Duel.IsExistingMatchingCard(c249000815.attfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ATTRIBUTE_DEVINE) then att=att+ATTRIBUTE_DEVINE end
	if Duel.GetLocationCountFromEx(tp)<=0 or att==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c249000817.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,ct+3,att)
	local tc=g:GetFirst()
	if not tc then return end
	local sumtype
	if tc:IsType(TYPE_SYNCHRO) then sumtype=SUMMON_TYPE_SYNCHRO else sumtype=SUMMON_TYPE_XYZ end
	if Duel.SpecialSummon(tc,sumtype,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsType(TYPE_XYZ) then
		c:CancelToGrave()
		Duel.Overlay(tc,Group.FromCards(c))
		local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
		if tc2 then
			Duel.Overlay(tc,tc2)
		end
	end
end
