--Arcade Miss Fortune
function c11000276.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c11000276.condition)
	e2:SetTarget(c11000276.target)
	e2:SetOperation(c11000276.operation)
	c:RegisterEffect(e2)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_SPSUM_PARAM)
	e4:SetRange(LOCATION_HAND)
	e4:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e4:SetCondition(c11000276.hspcon)
	c:RegisterEffect(e4)
	--coin
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(11000276,0))
	e5:SetCategory(CATEGORY_COIN)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetTarget(c11000276.cointg)
	e5:SetOperation(c11000276.coinop)
	c:RegisterEffect(e5)
end
function c11000276.spfilter(c)
	return c:IsFaceup() and c:IsCode(11000273)
end
function c11000276.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11000276.spfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function c11000276.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() or Duel.GetCurrentPhase()==PHASE_BATTLE
end
function c11000276.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x201) and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c11000276.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c11000276.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11000276.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c11000276.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c11000276.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
function c11000276.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c11000276.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=0
	if c:IsHasEffect(11000273) then
		res=1-Duel.SelectOption(tp,60,61)
	else res=Duel.TossCoin(tp,1) end
	if res==1 then
		local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
			end
	else
		local g=Duel.SelectMatchingCard(tp,c11000276.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c11000276.filter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end