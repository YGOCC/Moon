--Xyz-Eyes Witch
function c249000347.initial_effect(c)
	--special summon 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(249000347,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,249000346)
	e1:SetCondition(c249000347.condition)
	e1:SetCost(c249000347.cost)
	e1:SetTarget(c249000347.target)
	e1:SetOperation(c249000347.operation)
	c:RegisterEffect(e1)
end
function c249000347.confilter2(c,rkmin,rkmax)
	return c:GetRank() >= rkmin and c:GetRank() <= rkmax 
end
function c249000347.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000347.confilter2,tp,LOCATION_EXTRA,0,1,nil,1,4)
	and Duel.IsExistingMatchingCard(c249000347.confilter2,tp,LOCATION_EXTRA,0,1,nil,5,6)
	and Duel.IsExistingMatchingCard(c249000347.confilter2,tp,LOCATION_EXTRA,0,1,nil,7,99)
end
function c249000347.costfilter(c)
	return c:IsSetCard(0x4073) and not c:IsCode(249000347)  and c:IsAbleToRemoveAsCost()
end
function c249000347.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
	and Duel.IsExistingMatchingCard(c249000347.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000347.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000347.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000347.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000347.xyzfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false)
end
function c249000347.operation(e,tp,eg,ep,ev,re,r,rp)
	local xyzg=Duel.GetMatchingGroup(c249000347.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
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