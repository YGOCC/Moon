--Card-Mistress Magic Valkyria
function c249000590.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c249000590.thcon)
	e3:SetTarget(c249000590.thtg)
	e3:SetOperation(c249000590.thop)
	c:RegisterEffect(e3)
	--copy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,249000590)
	e4:SetCost(c249000590.copycost)
	e4:SetTarget(c249000590.copytg)
	e4:SetOperation(c249000590.copyop)
	c:RegisterEffect(e4)
	--synchro while face-up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_ADD_TYPE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(TYPE_SYNCHRO)
	c:RegisterEffect(e5)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c249000590.synlimit)
	c:RegisterEffect(e6)
end
function c249000590.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetLabel(),0,0x1)
end
function c249000590.addop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1,e:GetLabel())
	end
end
function c249000590.addcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c249000590.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c249000590.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c249000590.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_SPELL) and tc:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	else
		Duel.MoveSequence(tc,1)
	end
end
function c249000590.costfilter(c)
	return c:IsSetCard(0x1D4) and c:IsAbleToRemoveAsCost()
end
function c249000590.costfilter2(c)
	return c:IsDiscardable() and c:IsType(TYPE_SPELL)
end
function c249000590.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000590.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c249000590.costfilter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000590.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.DiscardHand(tp,c249000590.costfilter2,1,1,REASON_COST+REASON_DISCARD)
end
function c249000590.filter1(c,e,tp,eg,ep,ev,re,r,rp)
	local te=c:CheckActivateEffect(false,false,false)
	if c:IsType(TYPE_SPELL) and te then
		if c:IsSetCard(0x95) then
			local tg=te:GetTarget()
			return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
		else
			return true
		end
	end
	return false
end
function c249000590.filter2(c,e,tp,eg,ep,ev,re,r,rp)
	local te=c:CheckActivateEffect(false,false,false)
	if c:IsType(TYPE_SPELL) and not c:IsType(TYPE_EQUIP+TYPE_CONTINUOUS) and te then
		if c:IsSetCard(0x95) then
			local tg=te:GetTarget()
			return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
		else
			return true
		end
	end
	return false
end
function c249000590.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			return Duel.IsExistingTarget(c249000590.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler(),e,tp,eg,ep,ev,re,r,rp)
		else
			return Duel.IsExistingTarget(c249000590.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler(),e,tp,eg,ep,ev,re,r,rp)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.SelectTarget(tp,c249000590.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	else
		Duel.SelectTarget(tp,c249000590.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
end
function c249000590.copyop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local tpe=tc:GetType()
	local te=tc:GetActivateEffect()
	local tg=te:GetTarget()
	local co=te:GetCost()
	local op=te:GetOperation()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	Duel.ClearTargetCard()
	if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS)~=0 or tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
	elseif bit.band(tpe,TYPE_FIELD)~=0 then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
	else
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
	tc:CreateEffectRelation(te)
	if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
	if tg then
		if tc:IsSetCard(0x95) then
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		else
			tg(te,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	Duel.BreakEffect()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local etc=g:GetFirst()
	while etc do
		etc:CreateEffectRelation(te)
		etc=g:GetNext()
	end
	if op then 
		if tc:IsSetCard(0x95) then
			op(e,tp,eg,ep,ev,re,r,rp)
		else
			op(te,tp,eg,ep,ev,re,r,rp)
		end
	end
	tc:ReleaseEffectRelation(te)
	etc=g:GetFirst()
	while etc do
		etc:ReleaseEffectRelation(te)
		etc=g:GetNext()
	end
end
function c249000590.synlimit(e,c)
	if not c then return false end
	return c:IsLevelBelow(9)
end