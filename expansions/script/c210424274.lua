local card = c210424274
function card.initial_effect(c)
c:EnableCounterPermit(0x99)
c:SetCounterLimit(0x99,15)
c:EnableCounterPermit(0xc)
c:SetCounterLimit(0xc,3)
	--Field Spell
		local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,210424274+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTarget(card.target)
	e1:SetOperation(card.operation)
	c:RegisterEffect(e1)
		--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(card.accon)
	e2:SetOperation(card.acop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(card.thcost)
	e3:SetTarget(card.thtg)
	e3:SetOperation(card.thop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(card.destg)
	e4:SetValue(card.value)
	e4:SetOperation(card.desop)
	c:RegisterEffect(e4)
		--add counter
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_BECOME_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(card.accon1)
	e5:SetOperation(card.acop1)
	c:RegisterEffect(e5)
	--destroy&damage
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_CUSTOM+210424265)
	e6:SetCost(card.descost)
	e6:SetTarget(card.destg1)
	e6:SetOperation(card.desop1)
	c:RegisterEffect(e6)
	--atkup
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_ATKCHANGE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_ATTACK_ANNOUNCE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCondition(card.battlecon)
	e7:SetTarget(card.tg1)
	e7:SetOperation(card.op1)
	c:RegisterEffect(e7)
		--cannot remove
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetCode(EFFECT_CANNOT_REMOVE)
	e8:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e8)
end
function card.filter(c,tp)
	return c:IsCode(210424274)
end
function card.cfilter1(c)
	return c:IsCode(210424264)
end
function card.cfilter2(c)
	return c:IsCode(210424265)
end
function card.cfilter3(c)
	return c:IsCode(210424267)
end
function card.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(card.filter,tp,LOCATION_EXTRA,0,1,nil,tp) 
	and Duel.IsExistingMatchingCard(card.cfilter1,tp,LOCATION_ONFIELD+LOCATION_DECK,0,1,nil,tp)
	and Duel.IsExistingMatchingCard(card.cfilter2,tp,LOCATION_ONFIELD+LOCATION_DECK,0,1,nil,tp)
--	and Duel.IsExistingMatchingCard(card.cfilter3,tp,LOCATION_ONFIELD+LOCATION_DECK,0,1,nil,tp)
end
end
function card.operation(e,tp,eg,ep,ev,re,r,rp)

   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g1=Duel.SelectMatchingCard(tp,card.cfilter1,tp,LOCATION_ONFIELD+LOCATION_DECK,0,1,1,nil,tp)
    Duel.SendtoGrave(g1,REASON_EFFECT)
    local g2=Duel.SelectMatchingCard(tp,card.cfilter2,tp,LOCATION_ONFIELD+LOCATION_DECK,0,1,1,nil,tp)
    Duel.SendtoGrave(g2,REASON_EFFECT)
--	local g3=Duel.SelectMatchingCard(tp,card.cfilter3,tp,LOCATION_ONFIELD+LOCATION_DECK,0,1,1,nil,tp)
 --   Duel.SendtoGrave(g3,REASON_EFFECT)

	local tc=Duel.SelectMatchingCard(tp,card.filter,tp,LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
	if tc then

		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local c=e:GetHandler()
	c:AddCounter(0x99,3)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(card.aclimit)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e1)
	end
end
function card.aclimit(e,re,tp)
	return  re:GetHandler():IsCode(210424264,210424265) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:GetHandler():IsImmuneToEffect(e)
end
function card.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanAddCounter(tp,0x99,3,e:GetHandler()) 
end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x99)
end
function card.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	c:AddCounter(0x99,3)
end
end
function card.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x99,5,REASON_COST)
	end
	e:GetHandler():RemoveCounter(tp,0x99,5,REASON_COST)
end
function card.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666) and c:IsAbleToHand()
end
function card.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(card.thfilter,tp,LOCATION_DECK,0,1,nil) 
end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function card.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return
end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,card.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
end
function card.dfilter(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD) and not c:IsReason(REASON_REPLACE) and c:IsType(TYPE_SPELL+TYPE_TRAP)
	and c:IsSetCard(0x666) and c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end
function card.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
	local count=eg:FilterCount(card.dfilter,nil,tp)
	e:SetLabel(count)
	return count>0 and Duel.IsCanRemoveCounter(tp,1,0,0x99,count*3,REASON_EFFECT)
end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function card.value(e,c)
	return c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD) and c:IsType(TYPE_SPELL+TYPE_TRAP)
	and c:IsSetCard(0x666) and c:IsControler(e:GetHandlerPlayer()) and c:IsReason(REASON_EFFECT)
end
function card.desop(e,tp,eg,ep,ev,re,r,rp)
	local count=e:GetLabel()
	Duel.RemoveCounter(tp,1,0,0x99,count*3,REASON_EFFECT)
end
function card.filter4(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x666)
end
function card.accon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false
end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(card.filter4,1,nil,tp)
end
function card.acop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x99,1)
end
function card.battlecon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if d and a:GetControler()~=d:GetControler() then
	if a:IsControler(tp) then e:SetLabelObject(a)
	else e:SetLabelObject(d) end
	return true
	else return false end
end
function card.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=e:GetLabelObject()
	if chkc then return chkc==tc end
	if chk==0 then return tc:IsOnField() and tc:IsCanBeEffectTarget(e) and tc:IsSetCard(0x666) and tc:IsFaceup() end
	Duel.SetTargetCard(tc)
end
function card.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(300)
		tc:RegisterEffect(e1)
	end
end
function card.ctop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0xc)
	c:RemoveCounter(tp,0xc,ct,REASON_EFFECT) 
end
function card.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler() and e:GetHandler():GetCounter(0xc)==3 end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	e:GetHandler():RemoveCounter(tp,0xc,3,REASON_COST)
end
function card.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_ONFIELD end
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function card.desop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function card.filter5(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x666)
end
function card.accon1(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(card.filter5,1,nil,tp)
end
function card.acop1(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	e:GetHandler() c:AddCounter(0xc,1)
	if c:GetCounter(0xc)==3 then
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+210424265,re,0,0,p,0)
	end
end