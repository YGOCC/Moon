--Twilight-Mage Sorceress
function c249000707.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,249000707)
	e1:SetCondition(c249000707.hspcon)
	e1:SetCost(c249000707.hspcost)
	e1:SetTarget(c249000707.hsptg)
	e1:SetOperation(c249000707.hspop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71413901,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(c249000707.descon)
	e2:SetTarget(c249000707.destg)
	e2:SetOperation(c249000707.desop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(2490007071,ACTIVITY_SPSUMMON,c249000707.counterfilter1)
	Duel.AddCustomActivityCounter(2490007072,ACTIVITY_SUMMON,c249000707.counterfilter2)
end
function c249000707.counterfilter1(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c249000707.counterfilter2(c)
	return not c:IsLevelAbove(5)
end
function c249000707.rfilter1(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToRemoveAsCost()
end
function c249000707.rfilter2(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemoveAsCost()
end
function c249000707.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c249000707.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c249000707.rfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,c)
	local g2=Duel.GetMatchingGroup(c249000707.rfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,c)
	if chk==0 then return g1:GetCount() > 0 and g2:GetCount() > 0
		and Duel.GetCustomActivityCount(2490007071,tp,ACTIVITY_SPSUMMON)==0
		and Duel.GetCustomActivityCount(2490007072,tp,ACTIVITY_SUMMON)==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c249000707.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c249000707.sumtg)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg1=g1:Select(tp,1,1,nil)
	if not g1:GetFirst():IsAttribute(ATTRIBUTE_DARK) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,sg1:GetFirst())
		sg1:Merge(sg2)
	end
	Duel.Remove(sg1,POS_FACEUP,REASON_COST)
end
function c249000707.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c249000707.sumtg(e,c,tp,sumtp)
	return c:IsLevelAbove(5)
end
function c249000707.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c249000707.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_HAND) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c249000707.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1E8)
end
function c249000707.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000707.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c249000707.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c249000707.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c249000707.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000707.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c249000707.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c249000707.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
