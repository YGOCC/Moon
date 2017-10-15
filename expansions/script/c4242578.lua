--Lunar Phase: Moon Burst the Helpful Pony
function c4242578.initial_effect(c)
--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetDescription(aux.Stringid(4242578,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c4242578.condition)
	e1:SetCost(c4242578.cost)
	e1:SetTarget(c4242578.target)
	e1:SetOperation(c4242578.operation)
	c:RegisterEffect(e1)
end
function c4242578.condition(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a:GetControler()==tp and a:IsSetCard(0x666) and a:IsRelateToBattle())
		or (d and d:GetControler()==tp and d:IsSetCard(0x666) and d:IsRelateToBattle())
end
function c4242578.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c4242578.target(e,tp,eg,ep,ev,re,r,rp,chk)
   local c=e:GetHandler()
    if chk==0 then
        if e:GetLabel()~=100 then return false end
        e:SetLabel(0)
        return Duel.GetFlagEffect(tp,4242578)==0 and c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
	Duel.RegisterFlagEffect(tp,4242578,RESET_PHASE+PHASE_DAMAGE,0,1)
end 
function c4242578.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	if Duel.GetTurnPlayer()~=tp then a=Duel.GetAttackTarget() end
	if not a:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(1000)
	a:RegisterEffect(e1)
end
