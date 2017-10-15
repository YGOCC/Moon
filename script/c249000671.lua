--Monster Mastery-Knight
function c249000671.initial_effect(c)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30312361,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,249000671)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetTarget(c249000671.target)
	e1:SetOperation(c249000671.operation)
	c:RegisterEffect(e1)
	--immune monster
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c249000671.efilter)
	c:RegisterEffect(e2)
end
function c249000671.filter(c)
	return c:IsType(TYPE_EFFECT) and c:IsAbleToRemove() and c:IsLevelBelow(6)
end
function c249000671.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c249000671.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000671.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c249000671.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c249000671.resolvefilter(c)
	return c:IsSetCard(0x1E3) and c:IsType(TYPE_MONSTER)
end
function c249000671.revealfilter(c)
	return c:IsSetCard(0x1E3) and not c:IsPublic()
end
function c249000671.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	if Duel.IsExistingMatchingCard(c249000671.resolvefilter,tp,LOCATION_GRAVE,0,1,nil) then
	elseif Duel.IsExistingMatchingCard(c249000671.revealfilter,tp,LOCATION_HAND,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g2=Duel.SelectMatchingCard(tp,c249000671.revealfilter,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g2)
		Duel.ShuffleHand(tp)
	else return end
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=1 then return end
		local code=tc:GetOriginalCode()
		local ba=tc:GetBaseAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x00400000+RESET_PHASE+PHASE_END)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		local cid=c:CopyEffect(code,RESET_EVENT+0x00400000+RESET_PHASE+PHASE_END,1)
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(30312361,1))
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCountLimit(1)
		e3:SetReset(RESET_EVENT+0x00400000+RESET_PHASE+PHASE_END)
		e3:SetLabel(cid)
		e3:SetLabelObject(e2)
		e3:SetOperation(c249000671.rstop)
		c:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_PUBLIC)
		c:RegisterEffect(e4)
	end
end
function c249000671.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	local e2=e:GetLabelObject()
	local e1=e2:GetLabelObject()
	e1:Reset()
	e2:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c249000671.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

