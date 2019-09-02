--Starlignment of Dark Magic - Amara
--Scripted by: XGlitchy30
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cid.thcost)
	e1:SetTarget(cid.thtg)
	e1:SetOperation(cid.thop)
	c:RegisterEffect(e1)
	--extra effects
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(cid.eop)
	c:RegisterEffect(e2)
	local e2x=e2:Clone()
	e2x:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2x)
	local e2y=e2:Clone()
	e2y:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2y)
end
--FLAG LIST
-- id: Marks a monster that already underwent through the "prevent effect" procedure

--search
function cid.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cid.thfilter(c)
	return c:IsSetCard(0x2595) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FIEND) and c:IsAbleToHand()
end
function cid.hcheck(c,tp)
	return c:IsLocation(LOCATION_HAND) and c:IsControler(tp)
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			local og=g:Filter(cid.hcheck,nil,tp)
			if #og<=0 then return end
			Duel.ConfirmCards(1-tp,og)
			for tc in aux.Next(og) do
				--prevent hand effects
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(1,0)
				e1:SetValue(cid.actlimit)
				e1:SetLabel(tc:GetOriginalCode())
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
--SECONDARY-LEVEL EFFECT: prevent hand effects
function cid.actlimit(e,re,tp)
	return re:GetHandler():GetOriginalCode()==e:GetLabel() and bit.band(re:GetRange(),LOCATION_HAND)>0
end
--extra effects
function cid.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local opt=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
	if opt==0 then
		--control
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetCategory(CATEGORY_CONTROL)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetCountLimit(1,id+100)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTarget(cid.cttg)
		e1:SetOperation(cid.ctop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	else
		--apply spell effect
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,3))
		e1:SetCategory(CATEGORY_REMOVE)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1,id+200)
		e1:SetCondition(cid.apcon)
		e1:SetCost(cid.apcost)
		e1:SetTarget(cid.aptg)
		e1:SetOperation(cid.apply)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
	end
end
--control
function cid.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_FIEND) and c:IsAbleToGrave() and c:IsSetCard(0x2595)
		and (c:IsLocation(LOCATION_DECK) or c:IsFaceup())
end
function cid.controlfilter(c,e)
	return c:IsControlerCanBeChanged() and c:GetColumnGroup():IsExists(cid.clcheck,1,e:GetHandler(),c:GetControler())
end
function cid.clcheck(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x2595) and c:IsType(TYPE_MONSTER) and c:IsControler(1-tp)
end
function cid.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cid.controlfilter(chkc,e) end
	if chk==0 then return Duel.IsExistingTarget(cid.controlfilter,tp,0,LOCATION_MZONE,1,nil,e) 
		and Duel.IsExistingMatchingCard(cid.tgfilter,tp,LOCATION_DECK+LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,cid.controlfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function cid.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cid.tgfilter,tp,LOCATION_DECK+LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.GetControl(tc,tp,PHASE_END,2)
		end
	end
end
--apply trap effect
function cid.confilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FIEND)
end
function cid.apcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cid.confilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cid.apcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cid.apfilter(c)
	return c:GetType()==0x4 and c:IsAbleToRemove() and c:CheckActivateEffect(false,true,false)~=nil
end
function cid.aptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,1,true)
	end
	if chk==0 then return Duel.IsExistingTarget(cid.apfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(cid.apfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	if not g then return false end
	local te,eg,ep,ev,re,r,rp=g:GetFirst():CheckActivateEffect(false,true,true)
	e:SetLabelObject(te)
	Duel.ClearTargetCard()
	local tg=te:GetTarget()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
function cid.apply(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Remove(te:GetHandler(),POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end