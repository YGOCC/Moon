--- Onslaught
function c543516052.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(543516052,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,543516052)
	e1:SetTarget(c543516052.sumtg)
	e1:SetOperation(c543516052.sumop)
	c:RegisterEffect(e1) 
	--ATK Gain
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(543516052,1))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,543516049)
	e4:SetCondition(c543516052.atkcon)
	e4:SetOperation(c543516052.atkop)
	c:RegisterEffect(e4)
	--ATK Gain 2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(543516052,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,543516048)
	e3:SetOperation(c543516052.atkop2)
	c:RegisterEffect(e3)
end
function c543516052.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x21f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c543516052.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c543516052.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c543516052.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c543516052.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c543516052.sumop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	end
end
function c543516052.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e and (e:GetHandler():IsSetCard(0x21f)) or (e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM)
end
function c543516052.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
end
function c543516052.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x21f)
end
function c543516052.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c543516052.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end