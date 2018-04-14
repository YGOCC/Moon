--Medivatale Red Hoody
function c16000878.initial_effect(c)
			local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,16000878)
	e1:SetTarget(c16000878.target)
	e1:SetOperation(c16000878.operation)
	c:RegisterEffect(e1)
		c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c16000878.mtcon)
	e4:SetOperation(c16000878.mtop)
	c:RegisterEffect(e4)
end
function c16000878.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xab5) and not c:IsCode(16000878) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16000878.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c16000878.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c16000878.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c16000878.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c16000878.operation(e,tp,eg,ep,ev,re,r,rp)
	  local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)  then
Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
end
	Duel.SpecialSummonComplete()
end
function c16000878.ffilter(c)
	return c:IsRace(RACE_FAIRY)
end
function c16000878.mtcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetReasonCard()
	return  ec:GetMaterial():IsExists(c16000878.ffilter,1,nil) and r&(REASON_SUMMON+REASON_FUSION+REASON_SYNCHRO+REASON_RITUAL+REASON_XYZ+REASON_LINK)==0
end
function c16000878.mtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,16000878)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(16000878,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c16000878.negcon)
	e1:SetCost(c16000878.negcost)
	e1:SetTarget(c16000878.negtg)
	e1:SetOperation(c16000878.negop)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	   rc:RegisterFlagEffect(16000878,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c16000878.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+388)
end
function c16000878.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xab5)
end
function c16000878.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c16000878.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,4,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x88,4,REASON_COST)
end
function c16000878.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c16000878.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
