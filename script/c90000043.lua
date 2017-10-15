--Toxic Proto Type Lady
function c90000043.initial_effect(c)
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--Type Change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c90000043.target)
	e1:SetOperation(c90000043.operation)
	c:RegisterEffect(e1)
	--Destroy Replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c90000043.target2)
	e2:SetOperation(c90000043.operation2)
	e2:SetValue(c90000043.value)
	c:RegisterEffect(e2)
	--Damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c90000043.condition)
	e3:SetTarget(c90000043.target3)
	e3:SetOperation(c90000043.operation3)
	c:RegisterEffect(e3)
end
function c90000043.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c90000043.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c90000043.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c90000043.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c90000043.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_TUNER)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c90000043.filter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x14) and c:IsControler(tp) and c:IsLocation(LOCATION_SZONE) and not c:IsReason(REASON_REPLACE)
end
function c90000043.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c90000043.filter2,1,e:GetHandler(),tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(90000043,0)) then return true
	else return false end
end
function c90000043.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c90000043.value(e,c)
	return c90000043.filter2(c,e:GetHandlerPlayer())
end
function c90000043.filter3(c)
	return c:IsFaceup() and (c:GetAttack()~=c:GetBaseAttack() or c:GetDefense()~=c:GetBaseDefense())
end
function c90000043.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.IsExistingMatchingCard(c90000043.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c90000043.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local val=Duel.GetMatchingGroupCount(c90000043.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,nil)*200
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,val)
end
function c90000043.operation3(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end