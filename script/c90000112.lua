--Spectral Spread
function c90000112.initial_effect(c)
	--Change Battle Target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetCondition(c90000112.condition)
	e1:SetCost(c90000112.cost)
	e1:SetTarget(c90000112.target)
	e1:SetOperation(c90000112.operation)
	c:RegisterEffect(e1)
end
function c90000112.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	return r~=REASON_REPLACE and a:IsControler(1-tp) and bc:IsControler(tp) and bc:IsSetCard(0x5d)
end
function c90000112.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c90000112.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)>1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,Duel.GetAttacker())
end
function c90000112.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and a:IsAttackable() and not a:IsImmuneToEffect(e) then
		Duel.CalculateDamage(a,tc)
	end
end