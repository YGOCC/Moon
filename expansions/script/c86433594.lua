--Inf-fector:\Negative_Response
--Script by XGlitchy30
function c86433594.initial_effect(c)
	--MST negates
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c86433594.mstcon)
	e1:SetOperation(c86433594.mstop)
	c:RegisterEffect(e1)
	--apply effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(86433594,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,86433594)
	e2:SetTarget(c86433594.effecttg)
	e2:SetOperation(c86433594.effectop)
	c:RegisterEffect(e2)
end
local normalop=nil
--filters
--change operation
function c86433594.repop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsOnField() then
		normalop(e,tp,eg,ep,ev,re,r,rp)
	else
		Duel.Hint(HINT_CARD,e:GetHandlerPlayer(),86433594)
	end
end
--MST negates
function c86433594.mstcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (loc==LOCATION_MZONE or loc==LOCATION_SZONE or loc==LOCATION_FZONE or loc==LOCATION_PZONE) and not rc:IsSetCard(0x86f)
		and re:IsHasType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_IGNITION+EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_QUICK_O+EFFECT_TYPE_QUICK_F)
end
function c86433594.mstop(e,tp,eg,ep,ev,re,r,rp)
	local op=re:GetOperation()
	normalop=op
	Duel.ChangeChainOperation(ev,c86433594.repop)
end
--apply effects
function c86433594.effecttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c86433594.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c86433594.effectop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or not tc:IsFaceup() then return end
	if tc:IsType(TYPE_MONSTER) and tc:IsAbleToRemove() and Duel.GetFlagEffect(tp,86433594)==0 then
		if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_END)
			e1:SetReset(RESET_EVENT+EVENT_CHAIN_END)
			e1:SetLabelObject(tc)
			e1:SetCountLimit(1)
			e1:SetOperation(c86433594.retop)
			Duel.RegisterEffect(e1,tp)
			Duel.RegisterFlagEffect(tp,86433594,RESET_EVENT+EVENT_CUSTOM+86433594,0,1)
		end
	elseif (tc:GetType()==TYPE_SPELL or tc:GetType()==TYPE_TRAP or tc:GetType()==0x10002 or tc:GetType()==0x100004) and Duel.GetFlagEffect(tp,80433594)==0 then
		tc:CancelToGrave()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		Duel.RegisterFlagEffect(tp,80433594,RESET_EVENT+EVENT_CUSTOM+86433594,0,1)
	elseif (tc:GetType()==0x80002 or tc:GetType()==0x82 or (tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsType(TYPE_CONTINUOUS))) and tc:IsCanTurnSet() and Duel.GetFlagEffect(tp,81433594)==0 then
		tc:CancelToGrave()
		Duel.ChangePosition(tc,POS_FACEDOWN)
		tc:SetStatus(STATUS_SET_TURN,false)
		Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		Duel.RegisterFlagEffect(tp,81433594,RESET_EVENT+EVENT_CUSTOM+86433594,0,1)
	else
		return
	end
end
function c86433594.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end