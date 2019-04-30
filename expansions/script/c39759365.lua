--Sottomarinaio
--Script by XGlitchy30
function c39759365.initial_effect(c)
	--Deck Master
	aux.AddOrigDeckmasterType(c)
	aux.EnableDeckmaster(c,nil,nil,c39759365.mscon,c39759365.mscustom,nil,c39759365.penalty)
	--Ability: Water Reflection
	local ab0=Effect.CreateEffect(c)
	ab0:SetType(EFFECT_TYPE_FIELD)
	ab0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ab0:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	ab0:SetRange(LOCATION_SZONE)
	ab0:SetTargetRange(1,0)
	ab0:SetCondition(c39759365.prerevertcon)
	c:RegisterEffect(ab0)
	local ab=Effect.CreateEffect(c)
	ab:SetType(EFFECT_TYPE_FIELD)
	ab:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ab:SetCode(EFFECT_CHANGE_DAMAGE)
	ab:SetRange(LOCATION_SZONE)
	ab:SetTargetRange(0,1)
	ab:SetCondition(aux.CheckDMActivatedState)
	ab:SetValue(c39759365.damval)
	c:RegisterEffect(ab)
	--Monster Effects--
	--spell immunity
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c39759365.efilter)
	c:RegisterEffect(e1)
	--Register Total Ability Damage
	if not c39759365.global_check then
		c39759365.global_check=true
		local reg=Effect.CreateEffect(c)
		reg:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		reg:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		reg:SetCode(EVENT_BATTLE_DAMAGE)
		reg:SetCondition(c39759365.regdamcon)
		reg:SetOperation(c39759365.regdam)
		Duel.RegisterEffect(reg,0)
	end
end
c39759365.total = 0
--filters
function c39759365.aclimit(e,te)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:IsActiveType(TYPE_SPELL) and te:GetHandler():IsType(TYPE_FIELD)
end
function c39759365.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(TYPE_SPELL)
end
--Register Total Ability Damage
function c39759365.regdamcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.GetFlagEffect(ep,39759365)~=0 and Duel.GetFlagEffectLabel(ep,39759365)<2 and Duel.GetAttacker():IsControler(1-tp)
end
function c39759365.regdam(e,tp,eg,ep,ev,re,r,rp)
	c39759365.total = c39759365.total+ev
	Debug.Message("Total damage inflicted: "..tostring(c39759365.total))
end
--Deck Master Functions
function c39759365.DMCost(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c39759365.aclimit)
	Duel.RegisterEffect(e1,tp)
end
function c39759365.mscon(e,c)
	local tp=c:GetControler()
	local sg=Duel.GetMatchingGroup(Card.IsPosition,tp,LOCATION_MZONE,0,nil,POS_FACEUP_ATTACK)
	if sg:GetCount()<=0 then return false end
	local at1=sg:GetSum(Card.GetAttack)
	return at1>2000
end
function c39759365.mscustom(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if sg:GetCount()<=0 then return false end
	local tc=sg:GetFirst()
	while tc do
		if tc:GetAttack()>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			tc=sg:GetNext()
		end
	end
end
function c39759365.penalty(e,tp,eg,ep,ev,re,r,rp)
	if c39759365.total<=0 then return end
	Duel.Damage(tp,c39759365.total,REASON_EFFECT)
end
--Ability: Water Reflection
function c39759365.prerevertcon(e)
	local tp=e:GetHandlerPlayer()
	return aux.CheckDMActivatedState(e) and Duel.GetFlagEffect(1-tp,39759365)==0
end
function c39759365.damval(e,re,val,r,rp,rc)
	local tp=e:GetHandlerPlayer()
	if Duel.GetFlagEffect(1-tp,39759365)~=0 or bit.band(r,REASON_BATTLE)==0 then return val end
	Duel.RegisterFlagEffect(1-tp,39759365,RESET_PHASE+PHASE_END,0,1)
	Duel.SetFlagEffectLabel(1-tp,39759365,Duel.GetFlagEffectLabel(1-tp,39759365)+1)
	return math.ceil(val/2)
end