--Dragofinity Guard
function c249000988.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80244114,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetTarget(c249000988.sptg)
	e1:SetOperation(c249000988.spop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_ATTACK)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c249000988.condition)
	e2:SetTarget(c249000988.target)
	e2:SetOperation(c249000988.operation)
	c:RegisterEffect(e2)
end
function c249000988.spfilter(c,e,tp)
	return (c:IsType(TYPE_LINK) or c:IsType(TYPE_SYNCHRO)) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c249000988.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c249000988.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c249000988.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c249000988.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c249000988.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c249000988.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1FF)
end
function c249000988.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000988.cfilter,tp,LOCATION_GRAVE,0,1,c)
end
function c249000988.tgfilter(c)
	return (c:IsType(TYPE_SYNCHRO)  or c:IsType(TYPE_LINK)) and c:IsRace(RACE_DRAGON)
end
function c249000988.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c249000988.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c249000988.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c249000988.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_DESTROY_REPLACE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESETS_STANDARD)
		e1:SetTarget(c249000988.reptg)
		tc:RegisterEffect(e1)
	end
end
function c249000988.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetHandler():IsType(TYPE_LINK) then return e:GetHandler():GetAttack()>500 else return e:GetHandler():GetDefense()>500 end
	end
	if e:GetHandler():IsType(TYPE_LINK) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e:GetHandler():RegisterEffect(e1)
		return true
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-500)
		e:GetHandler():RegisterEffect(e1)
		return true
	end
end