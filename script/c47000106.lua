--Digimon Angels of Light and Hope
function c47000106.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetCondition(c47000106.condition)
	e1:SetCost(c47000106.cost)
	e1:SetTarget(c47000106.target)
	e1:SetOperation(c47000106.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c47000106.handcon)
	c:RegisterEffect(e2)
end
function c47000106.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c47000106.cfilter(c)
	return c:IsSetCard(0x3FB) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c47000106.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47000106.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c47000106.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c47000106.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_FACEUP_ATTACK) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c47000106.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectMatchingCard(tp,Card.IsPosition,tp,0,LOCATION_MZONE,1,1,nil,POS_FACEUP_ATTACK)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	end
end
function c47000106.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3FB) 
end
function c47000106.handcon(e)
	return Duel.IsExistingMatchingCard(c47000106.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
