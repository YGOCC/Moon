--Empire Light House
function c90000077.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c90000077.target1)
	e1:SetOperation(c90000077.operation)
	c:RegisterEffect(e1)
	--ATK Up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2d))
	e2:SetValue(c90000077.value)
	c:RegisterEffect(e2)
	--DEF Up
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,90000077)
	e4:SetCost(c90000077.cost)
	e4:SetTarget(c90000077.target2)
	e4:SetOperation(c90000077.operation)
	c:RegisterEffect(e4)
end
function c90000077.value(e,c)
	return Duel.GetCounter(0,1,1,0x1000)*100
end
function c90000077.filter(c)
	return c:GetCounter(0x1000)>0
end
function c90000077.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetFlagEffect(tp,90000077)==0 and Duel.IsExistingTarget(c90000077.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.CheckLPCost(tp,800) and Duel.SelectYesNo(tp,aux.Stringid(90000077,0)) then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.RegisterFlagEffect(tp,90000077,RESET_PHASE+PHASE_END,0,1)
		Duel.PayLPCost(tp,800)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,c90000077.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
		e:SetLabel(1)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetLabel(0)
	end
end
function c90000077.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,90000077)==0 and Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
	Duel.RegisterFlagEffect(tp,90000077,RESET_PHASE+PHASE_END,0,1)
	e:SetLabel(1)
end
function c90000077.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c90000077.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c90000077.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c90000077.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end