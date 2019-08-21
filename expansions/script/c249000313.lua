--Skill Learner Sprite
function c249000313.initial_effect(c)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30312361,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c249000313.condition)
	e1:SetCost(c249000313.cost)
	e1:SetTarget(c249000313.target)
	e1:SetOperation(c249000313.operation)
	c:RegisterEffect(e1)
end
function c249000313.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c249000313.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c249000313.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1B2)
end
function c249000313.tgfilter(c)
	return c:IsType(TYPE_EFFECT) and not c:IsSetCard(0x1B2) and c:IsAbleToRemove() and not c:IsForbidden()
end
function c249000313.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c249000313.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000313.filter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000313.tgfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c249000313.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c249000313.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	local g2=Duel.SelectMatchingCard(tp,c249000313.tgfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	if g2:GetCount() > 0 then
	if Duel.Remove(g2:GetFirst(),POS_FACEUP,REASON_EFFECT)~=1 then return end
	local cc=g2:GetFirst()	
	local code=cc:GetOriginalCode()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(code)
	tc:RegisterEffect(e1)
	tc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	end
end
