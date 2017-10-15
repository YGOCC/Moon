function c1020013.initial_effect(c)
	c:SetUniqueOnField(1,0,1020013)
	--synchro summon
	aux.AddSynchroProcedure(c,c1020013.tunfil,aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29343734,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c1020013.damcon)
	e1:SetOperation(c1020013.damop)
	c:RegisterEffect(e1)
end
function c1020013.tunfil(c)
	return c:IsRace(RACE_MACHINE) and c:GetLevel()==3
end
function c1020013.damcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c1020013.damfil(c)
	return c:IsFaceup() and c:IsSetCard(0xded) and c:IsType(TYPE_MONSTER)
end
function c1020013.damop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c1020013.damfil,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.Damage(1-tp,ct*200,REASON_EFFECT)
	Duel.Damage(tp,ct*200,REASON_EFFECT)
end
function c1020013.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c1020013.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c1020013.rmfilter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToRemove()
		and Duel.IsExistingTarget(c1020013.rmfilter,tp,0,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1020013.rmfilter,tp,0,LOCATION_ONFIELD,2,2,nil)
	Duel.SetTargetCard(g)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,3,0,0)
end
function c1020013.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	tc:AddCard(c)
	if not c:IsRelateToEffect(e) or not tc:GetCount()==2 then return end
	if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local fid=c:GetFieldID()
		local rct=1
		local oc=tc:GetFirst()
		while oc do
			if oc:IsPreviousLocation(LOCATION_MZONE) then
				oc:RegisterFlagEffect(1020013,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,rct,fid)
			else if oc:IsPreviousLocation(LOCATION_SZONE) then
				oc:RegisterFlagEffect(1020014,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,rct,fid)
				end
			end
			oc=tc:GetNext()
		end
		tc:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c1020013.retcon)
		e1:SetOperation(c1020013.retop)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
end
function c1020013.retfilter(c,fid)
	return c:GetFlagEffectLabel(1020013)==fid
end
function c1020013.retfilter1(c,fid)
	return c:GetFlagEffectLabel(1020014)==fid
end
function c1020013.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp or Duel.GetTurnCount()==e:GetValue() then return false end
	local g=e:GetLabelObject()
	if not (g:IsExists(c1020013.retfilter,1,nil,e:GetLabel()) or g:IsExists(c1020013.retfilter1,1,nil,e:GetLabel())) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c1020013.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local mg=g:Filter(c1020013.retfilter,nil,e:GetLabel())
	local sg=g:Filter(c1020013.retfilter1,nil,e:GetLabel())
	g:DeleteGroup()
	local tc=mg:GetFirst()
	while tc do
		Duel.ReturnToField(tc)
		tc=mg:GetNext()
	end
	local tc=sg:GetFirst()
	while tc do
		if tc:IsType(TYPE_CONTINUOUS) or tc:IsType(TYPE_FIELD) then
		Duel.ReturnToField(tc)
		else
		Duel.SendtoGrave(tc,REASON_RULE)
		end
		tc=sg:GetNext()
	end
end
