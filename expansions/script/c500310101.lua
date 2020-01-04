--Sweetiehard Power-Up
function c500310101.initial_effect(c)
	   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,500310101)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c500310101.cost)
	e1:SetTarget(c500310101.target)
	e1:SetOperation(c500310101.activate)
	c:RegisterEffect(e1) 
end
function c500310101.filter(c,e)
	return c:IsFaceup() and c:IsSetCard(0xa34) and c:IsType(TYPE_EVOLUTE)and c:GetEC() --c:GetStage()>c:GetCounter(0x1088) --c:GetCounter(0x1088)<=0
end
function c500310101.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c500310101.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c500310101.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c500310101.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c500310101.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c500310101.activate(e,tp,eg,ep,ev,re,r,rp)

	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local atk=tc:GetAttack()*2
		local def=tc:GetDefense()*2
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(atk)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetValue(def)
		tc:RegisterEffect(e2)
		--reduce battle damage
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CHANGE_DAMAGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(0,1)
		e3:SetValue(c500310101.damval)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		--local val = tc:GetStage() - tc:GetCounter(0x1088)
		tc:RefillEC()
	end
end
function c500310101.damval(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 and rc==e:GetHandler() then
		return dam/2
	else return dam end
end
