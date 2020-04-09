--"Lotus Spirit, the Convalescent Manipulator"
--Scripted by 'Márcio Eduine'
function c90887.initial_effect(c)
	c:SetUniqueOnField(1,0,90887)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c90887.operation)
	c:RegisterEffect(e2)
end
function c90887.filter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_DECK+LOCATION_HAND) and c:IsControler(tp) and c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsReason(REASON_EFFECT)
end
function c90887.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c90887.filter,nil,tp)
	if ct>0 then
		Duel.Recover(tp,300*ct,REASON_EFFECT)
	end
	ct=eg:FilterCount(c90887.filter,nil,1-tp)
	if ct>0 then
		Duel.Recover(1-tp,300*ct,REASON_EFFECT)
	end
end