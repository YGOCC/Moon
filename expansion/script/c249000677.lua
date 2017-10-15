--Xyz-Eyes Beast
function c249000677.initial_effect(c)
	--XYZ
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,249000677)
	e1:SetCondition(c249000677.condition)
	e1:SetCost(c249000677.cost)
	e1:SetTarget(c249000677.target)
	e1:SetOperation(c249000677.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,249000677)
	e2:SetCost(c249000677.cost2)
	c:RegisterEffect(e2)
end
function c249000677.confilter2(c,rkmin,rkmax)
	return c:GetRank() >= rkmin and c:GetRank() <= rkmax 
end
function c249000677.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000677.confilter2,tp,LOCATION_EXTRA,0,1,nil,1,4)
	and Duel.IsExistingMatchingCard(c249000677.confilter2,tp,LOCATION_EXTRA,0,1,nil,5,6)
	and Duel.IsExistingMatchingCard(c249000677.confilter2,tp,LOCATION_EXTRA,0,1,nil,7,99)
end
function c249000677.costfilter(c)
	return c:IsSetCard(0x4073) and c:IsAbleToRemoveAsCost()
end
function c249000677.costfilter2(c)
	return c:IsSetCard(0x4073) and not c:IsPublic()
end
function c249000677.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000677.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000677.costfilter2,tp,LOCATION_HAND,0,1,c)) and c:IsDiscardable() end
	local option
	if Duel.IsExistingMatchingCard(c249000677.costfilter2,tp,LOCATION_HAND,0,1,c)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000677.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000677.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000677.costfilter2,tp,LOCATION_HAND,0,1,c) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000677.costfilter2,tp,LOCATION_HAND,0,1,1,c)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000677.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c249000677.filter(c,e)
	return c:IsType(TYPE_MONSTER) and not c:IsImmuneToEffect(e)
end
function c249000677.lvfilter(c,lv)
	return c:GetLevel()==lv
end
function c249000677.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local g1=Duel.GetMatchingGroup(c249000677.filter,tp,LOCATION_HAND,0,c,e)
		local g2=Duel.GetMatchingGroup(c249000677.filter,tp,LOCATION_HAND,0,c,e)
		local gg=g1:GetFirst()
		local lv=0
		local mg1=Group.CreateGroup()
		local mg2=nil
		while gg do
			lv=gg:GetLevel()
			mg2=g2:Filter(c249000677.lvfilter,gg,lv)
			if mg2:GetCount()>0 then
				mg1:Merge(mg2)
				mg1:AddCard(gg)
			end		
			gg=g1:GetNext()
		end
		if mg1:GetCount()>1 and Duel.IsExistingMatchingCard(c249000677.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
		return true
		else
		return false
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000677.xyzfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false)
end
function c249000677.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g1=Duel.GetMatchingGroup(c249000677.filter,tp,LOCATION_HAND,0,nil,e)
	local g2=Duel.GetMatchingGroup(c249000677.filter,tp,LOCATION_HAND,0,nil,e)
	local gg=g1:GetFirst()
	local lv=0
	local mg1=Group.CreateGroup()
	local mg2=nil
	while gg do
		lv=gg:GetLevel()
		mg2=g2:Filter(c249000677.lvfilter,gg,lv)
		if mg2:GetCount()>0 then
			mg1:Merge(mg2)
			mg1:AddCard(gg)
		end		
		gg=g1:GetNext()
	end
	if mg1:GetCount()>1 and Duel.IsExistingMatchingCard(c249000677.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
		local tg1=mg1:Select(tp,1,1,nil):GetFirst()			
		local tg2=mg1:FilterSelect(tp,c249000677.lvfilter,1,1,tg1,tg1:GetLevel())
		tg2:AddCard(tg1)			
		if tg2:GetCount()<2 then return end
		local xyzg=Duel.GetMatchingGroup(c249000677.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if xyzg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:RandomSelect(tp,1):GetFirst()	
			if Duel.SpecialSummonStep(xyz,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) then
				Duel.Overlay(xyz,tg2)
				Duel.SpecialSummonComplete()
				xyz:CompleteProcedure()	
			end				
		end		
	end	
end
function c249000677.costfilter3(c)
	return c:IsSetCard(0x4073) and not c:IsCode(249000677)  and c:IsAbleToRemoveAsCost()
end
function c249000677.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
	and Duel.IsExistingMatchingCard(c249000677.costfilter3,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000677.costfilter3,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end