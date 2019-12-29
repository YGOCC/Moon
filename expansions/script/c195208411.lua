--created by Seth, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cid.condition)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.operation)
	c:RegisterEffect(e1)
end
function cid.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x83e) and c:IsType(TYPE_MONSTER)
end
function cid.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_REMOVED,0,1,nil)
		and eg:GetFirst():IsControler(1-tp) and Duel.GetAttackTarget()==nil and Duel.GetAttacker()~=nil
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_REMOVED,0,1,nil) and Duel.NegateAttack() then
		Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	end
end
