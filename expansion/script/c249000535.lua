--Extra-Tuning Mysterious Esper
function c249000535.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c249000535.spcost)
	e1:SetTarget(c249000535.sptg)
	e1:SetOperation(c249000535.spop)
	c:RegisterEffect(e1)
	--synchro limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.TRUE)
	c:RegisterEffect(e2)
	--battle indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetValue(c249000535.valcon)
	c:RegisterEffect(e3)
end
function c249000535.costfilter(c,lv)
	return c:IsLevelAbove(lv) and c:IsAbleToRemoveAsCost()
end
function c249000535.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c249000535.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,1)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount() > 1 and g:IsExists(Card.IsLevelAbove,1,nil,5) end
	local g1=Duel.SelectMatchingCard(tp,c249000535.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,5)
	local g2
	if g1:GetFirst():IsLocation(LOCATION_HAND) then 
		g2=Duel.SelectMatchingCard(tp,c249000535.costfilter,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),1)
	else
		g2=Duel.SelectMatchingCard(tp,c249000535.costfilter,tp,LOCATION_HAND,0,1,1,g1:GetFirst(),1)
	end
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	local lv=g1:GetSum(Card.GetLevel)
	e:SetLabel(lv)
end
function c249000535.spfilter(c,e,tp,lv)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsLevelAbove(1) and (c:GetLevel()+3 <= lv) and c:IsSetCard(0x1C9)
end
function c249000535.filter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToGrave() and not c:IsSetCard(0x1C9)
end
function c249000535.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000535.filter,tp,LOCATION_EXTRA,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000535.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,99) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000535.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsExistingMatchingCard(c249000535.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetLabel()) then return end
	if not Duel.IsExistingMatchingCard(c249000535.filter,tp,LOCATION_EXTRA,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c249000535.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)~= 0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=Duel.SelectMatchingCard(tp,c249000535.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetLabel()):GetFirst()
			if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP) then
				tc:CompleteProcedure()
			end
		end
	end
end
function c249000535.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end