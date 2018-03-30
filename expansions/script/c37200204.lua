--Assault Steer
--XGlitchy30
function c37200204.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37200204,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,37200204)
	e1:SetCondition(c37200204.atkcon)
	e1:SetOperation(c37200204.atkop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c37200204.val)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c37200204.aclimit)
	e3:SetCondition(c37200204.actcon)
	c:RegisterEffect(e3)
end
--filters
function c37200204.filter(c)
	return c:IsFaceup() and c:IsAttackPos()
end
--spsummon
function c37200204.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	e:SetLabelObject(tc)
	return tc and tc:IsControler(tp) and tc:IsRelateToBattle()
end
function c37200204.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if c:IsLocation(LOCATION_HAND) then
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	if tc:IsRelateToBattle() and tc:IsFaceup() and tc:IsControler(tp) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1800)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e1)
	end
end
end
end
--ATK value
function c37200204.val(e,c)
	return Duel.GetMatchingGroupCount(c37200204.filter,c:GetControler(),LOCATION_MZONE,0,e:GetHandler())*300
end
--actlimit
function c37200204.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c37200204.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()~=nil
	and e:GetHandler():GetSequence()+Duel.GetAttackTarget():GetSequence()==4
end