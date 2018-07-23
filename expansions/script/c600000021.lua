--Battlefield of the Army
function c600000021.initial_effect(c)
	--Activate
	local act=Effect.CreateEffect(c)
	act:SetType(EFFECT_TYPE_ACTIVATE)
	act:SetCode(EVENT_FREE_CHAIN)
	act:SetOperation(c600000021.fixreset)
	c:RegisterEffect(act)
	--check ATK changes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e0:SetCode(EVENT_CHAIN_ACTIVATING)
	e0:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
	e0:SetOperation(c600000021.start_reg)
	c:RegisterEffect(e0)
	local e0x=Effect.CreateEffect(c)
	e0x:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0x:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e0x:SetCode(EVENT_CHAIN_SOLVED)
	e0x:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
	e0x:SetLabelObject(e0)
	e0x:SetOperation(c600000021.check_reg)
	c:RegisterEffect(e0x)
	--atk & def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x24a8))
	e2:SetValue(400)
	c:RegisterEffect(e2)
	--Cannot Summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c600000021.sumlimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e6)
	--negate
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(600000021,0))
	e7:SetCategory(CATEGORY_NEGATE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCountLimit(1)
	e7:SetCost(c600000021.negcost)
	e7:SetTarget(c600000021.negtg)
	e7:SetOperation(c600000021.negop)
	c:RegisterEffect(e7)
	--destroy
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e8:SetRange(LOCATION_FZONE)
	e8:SetCode(EVENT_CUSTOM+600000021)
	e8:SetTarget(c600000021.tg)
	e8:SetOperation(c600000021.op)
	c:RegisterEffect(e8)
end
function c600000021.sumlimit(e,c)
	return not c:IsSetCard(0x24a8)
end
function c600000021.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x4a8,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x4a8,3,REASON_COST)
end
function c600000021.negfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c600000021.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c600000021.negfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c600000021.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c600000021.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
end
function c600000021.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c600000021.descon(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return tc~=e:GetHandler() and tc:IsFaceup() and tc:IsAttack(0)
end
function c600000021.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
    if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tc) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c600000021.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=eg:GetFirst()
    while tc do
    	if tc:IsAttack(0) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
		tc=eg:GetNext()
	end
end
function c600000021.preset(c)
	return c:IsType(TYPE_MONSTER) and c:GetAttack()>0
end
function c600000021.trigger(c)
	return c:GetFlagEffect(12345676)>0
end
--Activate
function c600000021.fixreset(e,tp,eg,ep,ev,re,r,rp)
	local reset=Duel.GetMatchingGroup(c600000021.trigger,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if reset:GetCount()<=0 then return end
	for i in aux.Next(reset) do
		if i:GetFlagEffect(12345676)>0 then
			i:ResetFlagEffect(12345676)
		end
	end
end
--check ATK changes
function c600000021.start_reg(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c600000021.preset,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,nil)
	local c1=g1:Clone()
	c1:KeepAlive()
	e:SetLabelObject(c1)
	if not e:GetLabelObject() then
		return
	end
end
function c600000021.check_reg(e,tp,eg,ep,ev,re,r,rp)
	local group=Group.CreateGroup()
	local c1=e:GetLabelObject():GetLabelObject()
	if not c1 then
		return
	end
	---register monsters
	for t0 in aux.Next(c1) do
		if t0:GetAttack()<=0 then
			t0:RegisterFlagEffect(12345676,RESET_PHASE+PHASE_END,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE,0)
			group:AddCard(t0)
		end
	end
	---trigger event
	if Duel.IsExistingMatchingCard(c600000021.trigger,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+600000021,e,0,0,tp,0)
	end
end
--destroy
function c600000021.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c600000021.trigger,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c600000021.trigger,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c600000021.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c600000021.trigger,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local reset=g:Clone()
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	for i in aux.Next(reset) do
		if i:GetFlagEffect(12345676)>0 then
			i:ResetFlagEffect(12345676)
		end
	end
end