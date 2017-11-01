--Zero Tactics
--Automate ID
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()

function scard.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(scard.condition)
	e1:SetOperation(scard.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCondition(scard.con)
	e2:SetTarget(scard.tg)
	e2:SetOperation(scard.op)
	c:RegisterEffect(e2)
	if not scard.global_check then
		scard.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(scard.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function scard.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,30000)==0 then 
		Duel.CreateToken(tp,30000)
		Duel.CreateToken(1-tp,30000)
		Duel.RegisterFlagEffect(0,30000,0,0,0)
	end
end
function scard.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	if not tc then return false end
	local bc=tc:GetBattleTarget()
	if tc and bc then
		return tc:IsZHERO()
	else return false end
end
function scard.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	if not tc then return false end
	local bc=tc:GetBattleTarget()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	if bc:IsFaceup() and tc:IsFaceup() then
		local atk1=bc:GetBaseAttack()
		local atk2=tc:GetBaseAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(atk2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
		bc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_BASE_ATTACK)
		e2:SetValue(atk1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
		tc:RegisterEffect(e2)
	end
end
function scard.con(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
end
function scard.filter(c)
	return c:IsFaceup() and (c:GetAttack()>0 or c:GetDefense()>0)
end
function scard.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(scard.filter,tp,0,LOCATION_MZONE,1,nil) and c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function scard.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.filter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(0)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	local c=e:GetHandler()
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(scard.aclimit)
	e3:SetCondition(scard.actcon)
	c:RegisterEffect(e3)
end
function scard.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function scard.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	if not (a and b) then return end
	return a and b and
		((a:IsFaceup() and a:IsZHERO() and a:IsControler(tp)) or
		(b:IsFaceup() and b:IsZHERO() and b:IsControler(tp)))
end
