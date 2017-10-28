--Swordsmasterror Dharc
function c240100256.initial_effect(c)
	--If this card attacks a Defense Position monster, inflict piercing battle damage.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e0)
	--Gains 200 ATK for each "Swordsmaster" monster that was destroyed within the last 2 Standby Phases while this card was on the field.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c240100256.val)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetOperation(c240100256.regop)
	c:RegisterEffect(e2)
	--If this card is destroyed: Target 1 "Swordsmaster" monster you control; it gains 800 ATK, also gain 800 LP.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetTarget(c240100256.target)
	e3:SetOperation(c240100256.operation)
	c:RegisterEffect(e3)
end
function c240100256.val(e,c)
	return c:GetFlagEffect(240100256)*200
end
function c240100256.rfilter(c)
	return c:IsSetCard(0xbb2) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c240100256.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(c240100256.rfilter,1,c) then
		c:RegisterFlagEffect(240100256,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,0,2)
	end
end
function c240100256.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xbb2)
end
function c240100256.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c240100256.filter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c240100256.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)
end
function c240100256.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
	Duel.Recover(tp,800,REASON_EFFECT)
end
