--Trap Mastery-Knight
function c249000673.initial_effect(c)
	--immune spell
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c249000673.efilter)
	c:RegisterEffect(e1)
	--copy effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(51728779,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,249000673)
	e2:SetCondition(c249000673.cpcon)
	e2:SetTarget(c249000673.cptg)
	e2:SetOperation(c249000673.cpop)
	c:RegisterEffect(e2)
end
function c249000673.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c249000673.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c249000673.cpfilter(c)
	return c:IsType(TYPE_TRAP) and (not c:IsType(TYPE_CONTINUOUS)) and c:IsAbleToDeck() and c:CheckActivateEffect(false,false,false)~=nil
end
function c249000673.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c249000673.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c249000673.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,false,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local co=te:GetCost()
	if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
function c249000673.resolvefilter(c)
	return c:IsSetCard(0x1E3) and c:IsType(TYPE_MONSTER)
end
function c249000673.revealfilter(c)
	return c:IsSetCard(0x1E3) and not c:IsPublic()
end
function c249000673.cpop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c249000672.resolvefilter,tp,LOCATION_GRAVE,0,1,nil) then
	elseif Duel.IsExistingMatchingCard(c249000672.revealfilter,tp,LOCATION_HAND,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g2=Duel.SelectMatchingCard(tp,c249000672.revealfilter,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g2)
		Duel.ShuffleHand(tp)
	else return end
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	Duel.BreakEffect()
	Duel.SendtoDeck(te:GetHandler(),nil,2,REASON_EFFECT)
end
function c249000673.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not se:GetHandler():IsSetCard(0x1E3)
end
