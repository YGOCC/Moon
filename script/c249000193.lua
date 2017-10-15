-- Zexal II
function c249000193.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(c249000193.matfilter),4,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(68144350,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c249000193.cost)
	e1:SetTarget(c249000193.target)
	e1:SetOperation(c249000193.operation)
	c:RegisterEffect(e1)
	--add spell/trap
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c249000193.crcost)
	e2:SetOperation(c249000193.crop)
	c:RegisterEffect(e2)
end
function c249000193.matfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c249000193.costfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsAbleToRemoveAsCost() and not c:IsType(TYPE_PENDULUM)
end
function c249000193.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000193.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000193.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000193.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsSetCard(0x7f) and c:IsType(TYPE_XYZ)
end
function c249000193.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c249000193.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000193.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000193.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsExistingMatchingCard(c249000193.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then return end
	local c=e:GetHandler()
	local t={}
	local i=1
	local p=1
	for i=0,4 do 
		if Duel.CheckLocation(tp,LOCATION_MZONE,i) then t[p]=i p=p+1 end
	end
	t[p]=nil
	local seq=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.MoveSequence(c,seq)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c249000193.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local c=e:GetHandler()
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) then
			local tc=g:GetFirst()
			if c:GetOverlayGroup():GetCount()>0 then
				Duel.BreakEffect()
				local g1=c:GetOverlayGroup()
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47660516,0))
				local mg2=g1:Select(tp,1,1,nil)
				local oc=mg2:GetFirst()
				Duel.Overlay(tc,mg2)
				Duel.RaiseSingleEvent(oc,EVENT_DETACH_MATERIAL,e,0,0,0,0)
			end
			tc:CompleteProcedure()
		end
	end
end
zexal_II_used_table_size=1
zexal_II_used_table={
-1,
}
function c249000193.nottablematch(id)
	for i=1,zexal_II_used_table_size do
		if zexal_II_used_table[i]==id then return false end
	end
	return true
end
function c249000193.crcostfilter1(c)
	return c:IsSetCard(0x107f) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c249000193.crcostfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c249000193.crcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000193.crcostfilter1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c249000193.crcostfilter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000193.crcostfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local g2=Duel.SelectMatchingCard(tp,c249000193.crcostfilter2,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g2,REASON_COST+REASON_DISCARD)
	e:SetLabel(g2:GetFirst():GetType())
end
function c249000193.crop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.AnnounceCard(tp)
	local token=Duel.CreateToken(tp,ac)
	while not (c249000193.nottablematch(ac) and token:GetType()==e:GetLabel())
	do
		ac=Duel.AnnounceCard(tp)
		token=Duel.CreateToken(tp,ac)
	end
	zexal_II_used_table[zexal_II_used_table_size+1]=ac
	zexal_II_used_table_size=zexal_II_used_table_size+1
	Duel.SendtoHand(token,nil,REASON_EFFECT)
end