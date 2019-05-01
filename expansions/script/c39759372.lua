--Esecutore dell'Ombra
--Script by XGlitchy30
function c39759372.initial_effect(c)
	--Deck Master
	aux.AddOrigDeckmasterType(c)
	aux.EnableDeckmaster(c,nil,nil,c39759372.mscon,nil,c39759372.penaltycon,c39759372.penalty)
	--Ability: Shadow Control
	local ab=Effect.CreateEffect(c)
	ab:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ab:SetCode(EVENT_SSET)
	ab:SetRange(LOCATION_SZONE)
	ab:SetCondition(c39759372.setcon)
	ab:SetOperation(c39759372.setop)
	c:RegisterEffect(ab)
	local ab2=Effect.CreateEffect(c)
	ab2:SetType(EFFECT_TYPE_QUICK_O)
	ab2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	ab2:SetCode(EVENT_FREE_CHAIN)
	ab2:SetRange(LOCATION_SZONE)
	ab2:SetCountLimit(1)
	ab2:SetCondition(aux.CheckDMActivatedState)
	ab2:SetTarget(c39759372.acttg)
	ab2:SetOperation(c39759372.actop)
	c:RegisterEffect(ab2)
	--Monster Effects--
	--immunity
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetCondition(c39759372.econ)
	e0:SetValue(c39759372.efilter)
	c:RegisterEffect(e0)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(39759372,3))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(c39759372.rmcon)
	e1:SetOperation(c39759372.rmop)
	c:RegisterEffect(e1)
end
--filters
function c39759372.actfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFacedown() and c:CheckActivateEffect(false,false,false)~=nil
end
function c39759372.setfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
--Deck Master Functions
function c39759372.DMCost(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SSET)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c39759372.mscon(e,c)
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,2,nil)
end
function c39759372.penaltycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
end
function c39759372.penalty(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+39759372)
	e1:SetOperation(c39759372.penalty_act)
	Duel.RegisterEffect(e1,1-tp)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+39759372,e,0,tp,1-tp,0)
end
function c39759372.penalty_act(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(39759372,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c39759372.setfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
			Duel.ConfirmCards(1-tp,g)
		end
	end
	e:Reset()
end
--Ability: Shadow Control
function c39759372.setcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.CheckDMActivatedState(e) and rp==1-tp
end
function c39759372.setop(e,tp,eg,ep,ev,re,r,rp)
	for i in aux.Next(eg) do
		if i:IsFacedown() then
			Duel.ConfirmCards(tp,i)
		end
	end
end
function c39759372.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c39759372.actfilter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectMatchingCard(tp,c39759372.actfilter,tp,0,LOCATION_SZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		e:SetLabelObject(tc)
		local typ=tc:GetType()
		local te=tc:GetActivateEffect()
		local cost=te:GetCost()
		local tg=te:GetTarget()
		local op=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		Duel.ChangePosition(tc,POS_FACEUP)
		Duel.ClearTargetCard()
		Duel.Hint(HINT_CARD,0,tc:GetCode())
		tc:CreateEffectRelation(te)
		if bit.band(typ,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
			tc:CancelToGrave(false)
		end
		if cost then cost(te,tp,eg,ep,ev,re,r,rp,1) end
		if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
		Duel.BreakEffect()
		local ch_info=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if ch_info then
			local etc=ch_info:GetFirst()
			while etc do
				etc:CreateEffectRelation(te)
				etc=ch_info:GetNext()
			end
		end
	end
end
function c39759372.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local te=tc:GetActivateEffect()
	local op=te:GetOperation()
	if op then op(te,tp,eg,ep,ev,re,r,rp) end
	tc:ReleaseEffectRelation(te)
	if etc then	
		etc=g:GetFirst()
		while etc do
			etc:ReleaseEffectRelation(te)
			etc=g:GetNext()
		end
	end
end
--Monster Effects--
--immunity
function c39759372.econ(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil)
end
function c39759372.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
--banish
function c39759372.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAbleToRemove()
end
function c39759372.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsAbleToRemove() then return end
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c39759372.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c39759372.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end