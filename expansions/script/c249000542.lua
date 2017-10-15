--H.A. Hero - Spell Paladin LV8
function c249000542.initial_effect(c)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(43237273,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,249000542)
	e1:SetTarget(c249000542.target)
	e1:SetOperation(c249000542.operation)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(41006930,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,249000540)
	e2:SetCondition(c249000542.rmcon)
	e2:SetTarget(c249000542.rmtg)
	e2:SetOperation(c249000542.rmop)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.FALSE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(61257789,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCountLimit(1)
	e4:SetTarget(c249000542.sumtg)
	e4:SetOperation(c249000542.sumop)
	c:RegisterEffect(e4)
end
c249000542.lvdncount=2
c249000542.lvdn={249000540,249000541}
function c249000542.spfilter(c)
	return c:GetLevel() > 0 and Duel.IsPlayerCanSpecialSummonMonster(tp,86871615,0,0x4011,c:GetBaseAttack(),c:GetBaseDefense(),
			c:GetOriginalLevel(),c:GetOriginalRace(),c:GetOriginalAttribute())
end
function c249000542.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c249000542.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c249000542.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function c249000542.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,86871615,0,0x4011, tc:GetBaseAttack(),tc:GetBaseDefense(),
			tc:GetOriginalLevel(),tc:GetOriginalRace(),tc:GetOriginalAttribute()) then return end
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local token=Duel.CreateToken(tp,86871615)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(tc:GetBaseAttack())
		e1:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(tc:GetBaseDefense())
		token:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(tc:GetOriginalLevel())
		token:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(tc:GetOriginalRace())
		token:RegisterEffect(e4)	
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetValue(tc:GetOriginalAttribute())
		token:RegisterEffect(e5)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CHANGE_CODE)
		e6:SetValue(tc:GetOriginalCodeRule())
		token:RegisterEffect(e6)
		local code=tc:GetOriginalCodeRule()
		if not tc:IsType(TYPE_TRAPMONSTER) then
			token:CopyEffect(code, RESET_EVENT)
		end
		local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e7:SetCode(EVENT_LEAVE_FIELD)
		e7:SetOperation(c249000542.spop3)
		token:RegisterEffect(e7,true)
		local e8=e1:Clone()
		e8:SetCode(EFFECT_ADD_TYPE)
		e8:SetValue(TYPE_EFFECT)
		token:RegisterEffect(e8)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c249000542.spop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(c:GetPreviousControler(),LOCATION_MZONE)<1 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(c:GetPreviousControler(),170000175,0xf,0x4011,1500,1500,4,RACE_WARRIOR,ATTRIBUTE_LIGHT,POS_FACEUP,c:GetPreviousControler()) then return end
	if c:IsReason(REASON_DESTROY) then
		local token=Duel.CreateToken(c:GetPreviousControler(),170000175)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(1500)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(1500)
		token:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(4)
		token:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e4:SetValue(ATTRIBUTE_LIGHT)
		token:RegisterEffect(e4)
		Duel.SpecialSummon(token,0,c:GetPreviousControler(),c:GetPreviousControler(),false,false,POS_FACEUP)
	end
	e:Reset()
end
function c249000542.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c249000542.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c249000542.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		e:GetHandler():RegisterFlagEffect(249000542,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
	end
end
function c249000542.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(249000542)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c249000542.sumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)
	end
end