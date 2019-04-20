--Orichalcos Refaro
function c32084025.initial_effect(c)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c0)
	c:RegisterEffect(e2)
	--change target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c32084025.condition)
	e1:SetTarget(c32084025.atktg)
	e1:SetOperation(c32084025.atkop)
	c:RegisterEffect(e1)
end
function c32084025.cfilter(c)
	return c:IsFaceup() and c:IsCode(32084000)
end
function c32084025.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.IsExistingMatchingCard(c32084025.cfilter,tp,LOCATION_SZONE,0,1,nil)
end
function c32084025.filter(c)
	return (not Duel.GetAttacker() or c~=Duel.GetAttacker()) and c~=Duel.GetAttackTarget()
end
function c32084025.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32084025.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c32084025.atkop(e,tp,eg,ep,ev,re,r,rp)
		local bc=Duel.GetAttackTarget()
		local g=Duel.GetMatchingGroup(c32084025.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(32084025,0))
			local tc=g:Select(tp,1,1,nil):GetFirst()
			local at=Duel.GetAttacker()
			if at:IsAttackable() and not at:IsImmuneToEffect(e) and not tc:IsImmuneToEffect(e) then
				Duel.CalculateDamage(at,tc)
			end
		end
end