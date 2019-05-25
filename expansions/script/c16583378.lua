--Antilementale Fiumevermiglio
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
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(cid.spcon)
	e2:SetTarget(cid.sptg)
	e2:SetOperation(cid.spop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,id+100)
	e3:SetCondition(cid.thcon)
	e3:SetTarget(cid.thtg)
	e3:SetOperation(cid.thop)
	c:RegisterEffect(e3)
end
--filters
function cid.cfilter(c)
	return c:IsSetCard(0xa6e) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE)
end
function cid.spfilter(c,e,tp)
	return ((c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_PYRO)) or (c:IsSetCard(0xa6e) and not c:IsAttribute(ATTRIBUTE_WATER))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.tdfilter(c,tp,sg,rec)
	if not rec then return false end
	if not c:IsSetCard(0xa6e) or not c:IsFaceup() or not c:IsAbleToDeck() then return false end
	if rec<4 then
		sg:AddCard(c)
		if Duel.IsExistingMatchingCard(cid.tdfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,sg,tp,sg,rec+1) then
			sg:RemoveCard(c)
			if sg:GetCount()==0 then sg:DeleteGroup() end
			return true
		end
	else
		sg:AddCard(c)
		if Duel.IsExistingMatchingCard(cid.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,sg) then
			sg:RemoveCard(c)
			return true
		end
	end
end
function cid.thfilter(c,sg)
	if not sg then return false end
	if not c:IsSetCard(0xa6e) or not c:IsAbleToHand() then return false end
	return not sg:IsExists(Card.IsCode,1,nil,c:GetCode())
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
--special summon
function cid.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cid.cfilter,1,e:GetHandler())
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cid.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
	end
end
--search
function cid.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_MATERIAL+REASON_LINK)==REASON_MATERIAL+REASON_LINK and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local sg=Group.CreateGroup()
		sg:KeepAlive()
		return Duel.IsExistingMatchingCard(cid.tdfilter,tp,LOCATION_REMOVED,0,5,nil,tp,sg,0) 
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,5,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
	local g,sg=Group.CreateGroup(),Group.CreateGroup()
	sg:KeepAlive()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	for i=0,4 do
		local tg=Duel.SelectMatchingCard(tp,cid.tdfilter,tp,LOCATION_REMOVED,0,1,1,g,tp,sg,i)
		g:AddCard(tg:GetFirst())
	end
	if g:GetCount()<5 then return end
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		local g=Duel.GetMatchingGroup(cid.thfilter,tp,LOCATION_DECK,0,nil,og)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end