--Antilementale Piogginferno
--Script by XGlitchy30
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--temporary banish
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(cid.reptg)
	e1:SetOperation(cid.repop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
	e2:SetTarget(cid.thtg)
	e2:SetOperation(cid.thop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(cid.effcon)
	e3:SetOperation(cid.effop)
	c:RegisterEffect(e3)
end
--filters
function cid.thfilter(c)
	return c:IsType(TYPE_MONSTER) and ((c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_PYRO)) or (not c:IsAttribute(ATTRIBUTE_WATER) and c:IsSetCard(0xa6e))) and c:IsAbleToHand()
end
function cid.srfilter(c,tp)
	return c:IsControler(tp) and c:GetDestination()==LOCATION_REMOVED and c:IsAbleToHand()
end
function cid.thrfilter(c)
	return c:GetFlagEffect(id+100)~=0
end
--temporary banish
function cid.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and re and rp==1-tp
		and e:GetHandler():IsOnField() and e:GetHandler():IsControler(tp) and e:GetHandler():IsAbleToRemove()
		and bit.band(e:GetHandler():GetDestination(),LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA+LOCATION_REMOVED)>0
	end
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		return true
	else 
		return false 
	end
end
function cid.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Hint(HINT_CARD,1-tp,id)
	local c=e:GetHandler()
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(c)
		e1:SetCondition(cid.retcon)
		e1:SetOperation(cid.retop)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		Duel.RegisterEffect(e1,tp)
	end
end
function cid.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local g=e:GetLabelObject()
	if not g then
		e:Reset()
		return false
	else 
		return true 
	end
end
function cid.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g:GetFlagEffectLabel(id)==fid then
		Duel.ReturnToField(g)
	end
end
--search
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cid.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--effect gain
function cid.effcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_LINK)~=0 and e:GetHandler():GetReasonCard():IsType(TYPE_LINK)
end
function cid.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(cid.srtg)
	e1:SetValue(cid.srop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
end
function cid.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return rp==tp and eg:IsExists(cid.srfilter,1,nil,tp) and e:GetHandler():GetFlagEffect(id)<=0 end
	if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		local g=eg:Filter(cid.srfilter,nil,tp)
		local ct=g:GetCount()
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			g=g:Select(tp,1,ct,nil)
		end
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_REMOVE_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(LOCATION_HAND)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(id+100,RESET_EVENT+0x1de0000+RESET_PHASE+PHASE_END,0,1)
			tc=g:GetNext()
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetCountLimit(1)
		e1:SetCondition(cid.thrcon)
		e1:SetOperation(cid.throp)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+0x1de0000+RESET_PHASE+PHASE_END,0,1)
		return true
	else return false end
end
function cid.srop(e,c)
	return false
end
function cid.thrcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cid.thrfilter,1,nil)
end
function cid.throp(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cid.thrfilter,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,#g,#g,nil)
	if #tg>0 then
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
		local chktg=tg:Filter(Card.IsLocation,nil,LOCATION_DECK)
		if #chktg>0 then
			for p=0,1 do
				if chktg:IsExists(Card.IsControler,1,nil,p) then
					Duel.ShuffleDeck(p)
				end
			end
		end
	end
end