--H.A. Hero - Time Space
function c249000543.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(249000543,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c249000543.spcon2)
	e1:SetTarget(c249000543.sptg2)
	e1:SetOperation(c249000543.spop2)
	c:RegisterEffect(e1)
	--sp summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c249000543.target2)
	e2:SetOperation(c249000543.operation2)
	c:RegisterEffect(e2)
	--special summon synchro
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12076263,0))
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c249000543.condition)
	e3:SetCost(c249000543.cost)
	e3:SetOperation(c249000543.operation)
	c:RegisterEffect(e3)
end
function c249000543.spfilter(c,tp)
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsType(TYPE_MONSTER)
	and c:IsSetCard(0x1CB)
end
function c249000543.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c249000543.spfilter,1,nil,tp)
end
function c249000543.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c249000543.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c249000543.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c249000543.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c249000543.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(1-tp) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e3=e1:Clone()
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		tc:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		tc:RegisterEffect(e4)
	end
end
function c249000543.ctfilter(c)
	return c:IsSetCard(0x1CB) and c:IsType(TYPE_MONSTER)
end
function c249000543.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c249000543.ctfilter,tp,LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>1
end
function c249000543.costfilter(c)
	return c:IsSetCard(0x1CB) and c:IsAbleToRemoveAsCost()
end
function c249000543.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000543.costfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000543.costfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000543.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local ac=Duel.AnnounceCard(tp)
	local tc=Duel.CreateToken(tp,ac)	
	while not (tc:IsLevelAbove(5) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsType(TYPE_SYNCHRO))
	do
		ac=Duel.AnnounceCard(tp)
		tc=Duel.CreateToken(tp,ac)
	end
	local sumct=tc:GetLevel()-2
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) then
		tc:SetTurnCounter(0)
		-- count standby phases
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetOperation(c249000543.count)
		e1:SetLabel(sumct)
		tc:RegisterEffect(e1)
		--special summon
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_IGNITION)
		e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e3:SetCountLimit(1)
		e3:SetRange(LOCATION_REMOVED)
		e3:SetCondition(c249000543.spcon)
		e3:SetTarget(c249000543.sptg)
		e3:SetOperation(c249000543.spop)
		tc:RegisterEffect(e3)
	end
end
function c249000543.count(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct>=e:GetLabel() then
		e:GetHandler():RegisterFlagEffect(249000543,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c249000543.spcon(e,c)
	return  e:GetHandler():GetFlagEffect(249000543)>0
end
function c249000543.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c249000543.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,0,REASON_RULE)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end