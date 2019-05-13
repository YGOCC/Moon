local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
--created by Zolanark, coded by Lyris
--Arthro-Guardian Orb of Protection
function cid.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCost(cid.cost1)
	e1:SetTarget(cid.tg1)
	e1:SetOperation(cid.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetProperty(0)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCost(cid.cost2)
	e2:SetTarget(cid.tg2)
	e2:SetOperation(cid.op2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,cid.chainfilter)
end
function cid.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_MONSTER)
end
function cid.cfilter1(c)
	return c:GetType()&0x81==0x81 and c:IsAbleToDeckAsCost()
end
function cid.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cid.cost2(e,tp,eg,ep,ev,re,r,rp,0) and Duel.IsExistingMatchingCard(cid.cfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	cid.cost2(e,tp,eg,ep,ev,re,r,rp,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cid.cfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.BreakEffect()
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cid.thfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function cid.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cid.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		local tc=Duel.GetFirstTarget()
		if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(aux.indoval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TO_GRAVE)
		e2:SetCondition(cid.tglimit)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function cid.tglimit(e)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:GetReasonEffect():GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function cid.cfilter2(c)
	return c:GetType()&0x81==0x81 and c:IsAbleToGraveAsCost()
end
function cid.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.cfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil)
		and Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0 and Duel.GetActivityCount(tp,ACTIVITY_ATTACK)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cid.cfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cid.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cid.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function cid.tgfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToGrave()
end
function cid.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function cid.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cid.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(cid.damval)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		Duel.RegisterEffect(e2,tp)
	end
end
function cid.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 and rp~=e:GetHandlerPlayer() then return 0
	else return val end
end
