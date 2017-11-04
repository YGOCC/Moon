--Starspeckled Dragon
--Design and Code by Kindrindra
local ref=_G['c'..28915055]
function ref.initial_effect(c)
	--Synchro
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,28915055)
	e1:SetCondition(ref.drcon)
	e1:SetTarget(ref.drtg)
	e1:SetOperation(ref.drop)
	c:RegisterEffect(e1)
	--Banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(37192109,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetCost(ref.rmcost)
	e2:SetTarget(ref.rmtg)
	e2:SetOperation(ref.rmop)
	c:RegisterEffect(e2)
end

function ref.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function ref.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function ref.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function ref.rmfilter(c)
	return c:IsAbleToRemove() and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function ref.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	if Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(28915055,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(c)
		e1:SetCondition(ref.retcon)
		e1:SetOperation(ref.retop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function ref.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and ref.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(ref.rmfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(ref.rmfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function ref.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,ref.rmfilter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local fid=tc:GetFieldID()
		tc:RegisterFlagEffect(28915055,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(ref.retcon)
		e1:SetOperation(ref.retop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
--Return
function ref.retfilter(c,fid)
	return c:GetFlagEffectLabel(37192109)==fid
end
function ref.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(ref.retfilter,1,nil,e:GetLabel()) then
		e:Reset()
		return false
	else return true end
end
function ref.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(ref.retfilter,nil,e:GetLabel())
	local tc=sg:GetFirst()
	while tc do
		Duel.ReturnToField(tc)
		tc=sg:GetNext()
	end
end