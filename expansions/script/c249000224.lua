--Dark Pendulum Angel Knight
function c249000224.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--return to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE_START+PHASE_BATTLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c249000224.retcon)
	e2:SetTarget(c249000224.rettg)
	e2:SetOperation(c249000224.retop)
	c:RegisterEffect(e2)
	--level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_DECK)
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(4)
	c:RegisterEffect(e3)
	--scale
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_LSCALE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c249000224.slcon)
	e4:SetValue(6)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e5)
	--p summon sucess
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetCondition(c249000224.condition)
	e6:SetTarget(c249000224.target)
	e6:SetOperation(c249000224.operation)
	c:RegisterEffect(e6)
	Duel.AddCustomActivityCounter(249000224,ACTIVITY_SPSUMMON,c249000224.counterfilter)
end
function c249000224.counterfilter(c)
	return not c:GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c249000224.slfilter(c)
	return c:IsRace(RACE_WARRIOR)
end
function c249000224.slcon(e)
	return not Duel.IsExistingMatchingCard(c249000224.slfilter,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler())
end
function c249000224.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(249000224,tp,ACTIVITY_SPSUMMON) > 0
end
function c249000224.retfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:GetPreviousLocation()==LOCATION_EXTRA
end
function c249000224.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsController(tp)
	and c249000224.retfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000224.retfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c249000224.retfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c249000224.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c249000224.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c249000224.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c249000224.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT) and c:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(800)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_EXTRA_ATTACK)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)	
			e2:SetCondition(c249000224.atkcon)
			c:RegisterEffect(e2)
		end
	end
end
function c249000224.atkcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)>0
end