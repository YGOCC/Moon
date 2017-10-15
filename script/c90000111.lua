--Spectral Breaker
function c90000111.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,90000111)
	e2:SetCondition(c90000111.condition)
	e2:SetOperation(c90000111.operation)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetLabelObject(e2)
	e3:SetCondition(c90000111.condition2)
	e3:SetTarget(c90000111.target)
	e3:SetOperation(c90000111.operation2)
	c:RegisterEffect(e3)
end
function c90000111.filter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c90000111.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if a:IsControler(1-tp) then a,bc=bc,a end
	return a:IsSetCard(0x5d) and a:IsRelateToBattle() and a:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c90000111.filter,tp,LOCATION_MZONE,0,1,a,a:GetCode())
end
function c90000111.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local a=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,bc=bc,a end
	if a:IsRelateToBattle() and a:IsFaceup() and Duel.Remove(a,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.Recover(tp,a:GetAttack(),REASON_EFFECT)
		c:RegisterFlagEffect(90000111,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
		a:RegisterFlagEffect(90000111,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
		e:SetLabelObject(a)
	end
end
function c90000111.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject():GetLabelObject()
	return tc and Duel.GetTurnCount()~=tc:GetTurnID() and c:GetFlagEffect(90000111)~=0 and tc:GetFlagEffect(90000111)~=0
end
function c90000111.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject():GetLabelObject()
	if chk==0 then return tc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	tc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function c90000111.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject():GetLabelObject()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end