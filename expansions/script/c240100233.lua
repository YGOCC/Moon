--Reneutrix Night Club
function c240100233.initial_effect(c)
	--When this card is activated: You can add 1 "Reneutrix" card from your Deck to your hand, except "Reneutrix Night Club".
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c240100233.activate)
	c:RegisterEffect(e1)
	--Once per turn: You can target 1 face-up card in your opponent's Spell & Trap Zone; while this card is in the Field Zone, that card remains on the field after activation, also it cannot activate its effects until the End Phase, and your opponent must activate 1 of its effects during the End Phase or else send it to the GY.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(240100233,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c240100233.target)
	e2:SetOperation(c240100233.operation)
	c:RegisterEffect(e2)
	--"Reneutrix" monsters do not have to activate their effects.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(240100233)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0xff,0xff)
	c:RegisterEffect(e3)
end
function c240100233.thfilter(c)
	return c:IsSetCard(0xd10) and c:IsAbleToHand() and not c:IsCode(240100233)
end
function c240100233.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c240100233.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(240100233,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c240100233.cfilter(c)
	return c:IsFaceup() and c:GetSequence()<5
end
function c240100233.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_SZONE) and c240100233.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c240100233.cfilter,tp,0,LOCATION_SZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(240100233,2))
	Duel.SelectTarget(tp,c240100233.cfilter,tp,0,LOCATION_SZONE,1,1,e:GetHandler())
	--[[Duel.SetChainLimit(c240100233.chainlimit)
end
function c240100233.chainlimit(e,rp,tp)
	return tp==rp or not e:IsActiveType(TYPE_SPELL+TYPE_TRAP)]]
end
function c240100233.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		e:SetLabelObject(tc)
		c:ResetFlagEffect(240100233)
		tc:ResetFlagEffect(240100233)
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(240100233,RESET_EVENT+0x1fe0000,0,1,fid)
		tc:RegisterFlagEffect(240100233,RESET_EVENT+0x1fe0000,0,1,fid)
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_REMAIN_FIELD)
		e0:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e0:SetReset(RESET_EVENT+0x1fe0000)
		e0:SetCondition(c240100233.rcon)
		tc:RegisterEffect(e0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DRAW)
		e1:SetLabelObject(tc)
		e1:SetCondition(c240100233.rcon)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DRAW)
		e2:SetLabel(fid)
		e2:SetLabelObject(e1)
		e2:SetCondition(c240100233.rstcon)
		e2:SetOperation(c240100233.rstop)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DRAW)
		e3:SetLabel(fid)
		e3:SetLabelObject(tc)
		e3:SetCondition(c240100233.agcon)
		e3:SetOperation(c240100233.agop)
		Duel.RegisterEffect(e3,1-tp)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCode(EVENT_CHAINING)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DRAW)
		e4:SetLabel(tc:GetFieldID())
		e4:SetLabelObject(e3)
		e4:SetOperation(c240100233.rstop2)
		Duel.RegisterEffect(e4,tp)
	end
end
function c240100233.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler()) and e:GetHandler():GetFlagEffect(240100233)~=0
end
function c240100233.rstcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject():GetLabelObject()
	if tc:GetFlagEffectLabel(240100233)==e:GetLabel()
		and c:GetFlagEffectLabel(240100233)==e:GetLabel() then
		return not c:IsDisabled()
	else
		e:Reset()
		return false
	end
end
function c240100233.rstop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	te:Reset()
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
end
function c240100233.agcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(240100233)==e:GetLabel()
		and c:GetFlagEffectLabel(240100233)==e:GetLabel() then
		return not c:IsDisabled()
	else
		e:Reset()
		return false
	end
end
function c240100233.agop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_RULE)
end
function c240100233.rstop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:GetFlagEffectLabel(240100233)~=e:GetLabel() then return end
	local c=e:GetHandler()
	c:CancelCardTarget(tc)
	local te=e:GetLabelObject()
	tc:ResetFlagEffect(240100233)
	if te then te:Reset() end
end
