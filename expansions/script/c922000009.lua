--ミラーフォース・ドラゴン
function c922000009.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--Activate
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_IGNITION)
	--e2:SetRange(LOCATION_MZONE)
	--e2:SetCountLimit(1)
	--e2:SetCondition(c922000009.abpcon)
	--e2:SetOperation(c922000009.activate)
	--c:RegisterEffect(e2)
	--Immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c922000009.bpcon)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c922000009.bpcon)
	e4:SetValue(c922000009.tgvalue)
	e4:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e4)
	
	--add code
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
--	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	--e5:SetTarget(c922000007.target)
	e5:SetOperation(c922000009.activate)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
end
c922000009.material_spell=72302403
function c922000009.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c922000009.bpcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
end
function c922000009.abpcon(e)
	return not e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
end
function c922000009.activate(e,tp,eg,ep,ev,re,r,rp)
--	local c=e:GetHandler()
--	if c:IsAttackPos() then
--		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
--	end
--	local e1=Effect.CreateEffect(c)
--	e1:SetType(EFFECT_TYPE_SINGLE)
--	e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
--	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_COPY_INHERIT)
--	c:RegisterEffect(e1)
	--destroy
--	local e2=Effect.CreateEffect(e:GetHandler())
--	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
--	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
--	e2:SetCode(EVENT_PHASE+PHASE_END)
--	e2:SetCountLimit(1)
--	e2:SetRange(LOCATION_MZONE)
--	e2:SetCondition(c922000009.descon)
--	e2:SetOperation(c922000009.desop)
	--e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	--e:GetHandler():RegisterEffect(e2)
	
	--destroy
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c922000009.descon)
	e2:SetOperation(c922000009.desop)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	e:GetHandler():RegisterFlagEffect(922000009,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,3)
	e:GetHandler():RegisterEffect(e2)
	e:GetHandler():SetTurnCounter(0)
end
function c922000009.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c922000009.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==3 then
		Duel.Destroy(c,REASON_RULE)
		c:ResetFlagEffect(922000009)
	end
end