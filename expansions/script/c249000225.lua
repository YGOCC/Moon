--Steel Pendulum Knight
function c249000225.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetOperation(c249000225.caop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c249000225.etarget)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--atk
	local e3=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c249000225.atktg)
	e4:SetValue(300)
	c:RegisterEffect(e4)
end
function c249000225.caop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if Duel.GetAttacker()==c and bc and c:IsRelateToBattle() and c:IsChainAttackable() then
		Duel.ChainAttack()
	end
end
function c249000225.etarget(e,c)
	return c:GetTurnID()==Duel.GetTurnCount() and c:GetSummonType()==SUMMON_TYPE_PENDULUM and c:GetPreviousLocation()==LOCATION_HAND
end
function c249000235.atktg(e,c)
	return c:GetSummonType()==SUMMON_TYPE_PENDULUM
end