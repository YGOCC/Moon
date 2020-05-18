--Moon's Dream: Inner Demon
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
c:SetUniqueOnField(1,0,id)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(cid.cost)
	e2:SetTarget(cid.btg)
	e2:SetOperation(cid.bop)
	c:RegisterEffect(e2)
		--atk/def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(cid.battlecon)
	e4:SetTarget(cid.atktg)
	e4:SetValue(cid.atkval)
	e4:SetOperation(cid.atkop)
	c:RegisterEffect(e4)
end
--filters
function cid.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666)
end
function cid.atkval(e,c)
	local g=Duel.GetMatchingGroup(cid.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)*500
end
function cid.tdfilter(c)
	return c:IsSetCard(0x666) and c:IsAbleToDeck()
end
function cid.filter(c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER+TYPE_PENDULUM)
end
function cid.searchfilter(c,e,tp)
	return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_FUSION)
end
--Banish
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return Duel.IsExistingMatchingCard(cid.searchfilter,tp,LOCATION_GRAVE,0,1,c) end
	local g=Duel.SelectMatchingCard(tp,cid.searchfilter,tp,LOCATION_GRAVE,0,1,1,c)
	
	if Card.Type then 
		local tc=g:GetFirst()
			Card.Type(tc,TYPE_PENDULUM+TYPE_MONSTER+TYPE_EFFECT) 
				Duel.RemoveCards(tc,nil,REASON_COST+REASON_RULE)
					Duel.SendtoExtraP(tc,POS_FACEUP,REASON_RULE+REASON_RETURN)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function() if not tc:IsLocation(LOCATION_EXTRA) then Card.Type(tc,TYPE_EFFECT+TYPE_MONSTER) Card.Race(tc,RACE_BEAST)  e1:Reset() e1:GetLabelObject():Reset() end end)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_SOLVED)
	Duel.RegisterEffect(e2,tp)
	e1:SetLabelObject(e2)
	else
	local tc=g:GetFirst()
			tc:SetCardData(CARDDATA_TYPE,tc:GetType()+TYPE_PENDULUM)
				Duel.Exile(tc,REASON_COST+REASON_RULE)
					Duel.SendtoExtraP(tc,POS_FACEUP,REASON_RULE+REASON_RETURN)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function() if not tc:IsLocation(LOCATION_EXTRA) then tc:SetCardData(CARDDATA_TYPE,tc:GetType()-TYPE_PENDULUM) e1:Reset() e1:GetLabelObject():Reset() end end)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_SOLVED)
	Duel.RegisterEffect(e2,tp)
	e1:SetLabelObject(e2)
	end
end	
function cid.btg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and aux.TRUE(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end

function cid.bop(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	local option
	if not tc:IsDisabled() then option=0 end
	if tc:IsDestructable() then option=1 end
	if not tc:IsDisabled() and tc:IsDestructable() then
		option=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1)) end
	if option==0 then 
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(tc)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
	end
	if option==1 then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
end
--Battle bonus
function cid.battlecon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d~=nil and d:IsFaceup() and ((a:GetControler()==tp and a:IsSetCard(0x666) and a:IsRelateToBattle())
		or (d:GetControler()==tp and d:IsSetCard(0x666) and  d:IsRelateToBattle()))
end
function cid.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if bc:IsControler(1-tp) then bc=tc end
	e:SetLabelObject(bc)
	return bc:IsFaceup() and bc:IsSetCard(0x666)
end
function cid.atkop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or a:IsFacedown() or not d:IsRelateToBattle() or d:IsFacedown() then return end
	if a:IsControler(1-tp) then a,d=d,a end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(cid.atkval)
	a:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
	e2:SetValue(cid.atkval)
	a:RegisterEffect(e2)
end

