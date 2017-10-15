--Extra-Tuning Floral Maiden
function c249000531.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c249000531.spcost)
	e1:SetTarget(c249000531.sptg)
	e1:SetOperation(c249000531.spop)
	c:RegisterEffect(e1)
	--synchro limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.TRUE)
	c:RegisterEffect(e2)
	--pos
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79409334,0))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetTarget(c249000531.target)
	e3:SetOperation(c249000531.operation)
	c:RegisterEffect(e3)
end
function c249000531.costfilter(c,lv)
	return c:IsLevelAbove(lv) and c:IsAbleToRemoveAsCost()
end
function c249000531.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c249000531.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,1)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount() > 1 and g:IsExists(Card.IsLevelAbove,1,nil,5) end
	local g1=Duel.SelectMatchingCard(tp,c249000531.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,5)
	local g2
	if g1:GetFirst():IsLocation(LOCATION_HAND) then 
		g2=Duel.SelectMatchingCard(tp,c249000531.costfilter,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),1)
	else
		g2=Duel.SelectMatchingCard(tp,c249000531.costfilter,tp,LOCATION_HAND,0,1,1,g1:GetFirst(),1)
	end
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	local lv=g1:GetSum(Card.GetLevel)
	e:SetLabel(lv)
end
function c249000531.spfilter(c,e,tp,lv)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsLevelAbove(1) and (c:GetLevel()+1 <= lv) and c:IsSetCard(0x1C9)
end
function c249000531.filter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToGrave() and not c:IsSetCard(0x1C9)
end
function c249000531.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000531.filter,tp,LOCATION_EXTRA,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000531.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,99) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000531.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsExistingMatchingCard(c249000531.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetLabel()) then return end
	if not Duel.IsExistingMatchingCard(c249000531.filter,tp,LOCATION_EXTRA,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c249000531.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)~= 0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g1=Duel.SelectMatchingCard(tp,c249000531.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetLabel())
			if g1:GetCount()>0 then
				Duel.SpecialSummon(g1,0,tp,tp,true,false,POS_FACEUP)
			end
		end
	end
end
function c249000531.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAttackPos() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c249000531.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsPosition(POS_FACEUP_ATTACK) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end