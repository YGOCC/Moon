--Dragonic Pendulum Knight
function c249000226.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--return to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE_START+PHASE_BATTLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c249000226.damcon)
	e2:SetTarget(c249000226.damtg)	
	e2:SetOperation(c249000226.damop)
	c:RegisterEffect(e2)
	--scale
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_LSCALE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c249000226.slcon)
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
	e6:SetCondition(c249000226.condition)
	e6:SetTarget(c249000226.target)
	e6:SetOperation(c249000226.operation)
	c:RegisterEffect(e6)
	Duel.AddCustomActivityCounter(249000226,ACTIVITY_SPSUMMON,c249000226.counterfilter)
end
function c249000226.counterfilter(c)
	return not c:GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c249000226.slfilter(c)
	return c:IsRace(RACE_WARRIOR)
end
function c249000226.slcon(e)
	return not Duel.IsExistingMatchingCard(c249000226.slfilter,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler())
end
function c249000226.damfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:GetPreviousLocation()==LOCATION_EXTRA
end
function c249000226.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000226.damfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLP(tp) >= 3000
end
function c249000226.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return true end
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function c249000226.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,1000,REASON_EFFECT)
end
function c249000226.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c249000226.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c249000226.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT) then
			Duel.Damage(1-tp,1000,REASON_EFFECT)
		end
	end
end