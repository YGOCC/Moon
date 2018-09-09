--Emissarius dell'Organizzazione Angeli, Lugria
--Script by =£1G*
function c16599455.initial_effect(c)
	--target protection
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(c16599455.efilter)
	c:RegisterEffect(e0)
	--spsummon procedure
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16599455,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c16599455.sprcon)
	e1:SetOperation(c16599455.sprop)
	c:RegisterEffect(e1)
	--dual attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetCondition(c16599455.attribute)
	e2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e2)
	--light effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16599455,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,16599455)
	e3:SetCondition(c16599455.damcon)
	e3:SetCost(c16599455.damcost)
	e3:SetTarget(c16599455.damtg)
	e3:SetOperation(c16599455.damop)
	c:RegisterEffect(e3)
	--dark effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16599455,2))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,26599455)
	e4:SetCondition(c16599455.dgcon)
	e4:SetTarget(c16599455.dgtg)
	e4:SetOperation(c16599455.dgop)
	c:RegisterEffect(e4)
	--change damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_REMOVE)
	e5:SetCondition(c16599455.chgcon)
	e5:SetOperation(c16599455.chgop)
	c:RegisterEffect(e5)
	--Register Damage
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	ge0:SetCode(EVENT_DAMAGE)
	ge0:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_SZONE)
	ge0:SetLabelObject(e4)
	ge0:SetCondition(c16599455.regcon)
	ge0:SetOperation(c16599455.register)
	c:RegisterEffect(ge0)
	--Reset Damage
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	ge1:SetCode(EVENT_TURN_END)
	ge1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_SZONE)
	ge1:SetCountLimit(1)
	ge1:SetLabelObject(e4)
	ge1:SetCondition(c16599455.resetcon)
	ge1:SetOperation(c16599455.reset)
	c:RegisterEffect(ge1)
end
-----Register Damage-----
function c16599455.regcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c16599455.register(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(e:GetLabelObject():GetLabel()+ev)
end
-----Reset Damage-----
function c16599455.resetcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()>0
end
function c16599455.reset(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
end
-------------------------
--filters
function c16599455.cfilter1(c,tp)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToRemoveAsCost()
		and c:GetAttack()==0 and Duel.IsExistingMatchingCard(c16599455.cfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c16599455.cfilter2(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemoveAsCost()
		and c:GetAttack()==0
end
function c16599455.ctfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c16599455.lfilter1(c,tp)
	return c:IsSetCard(0x1559) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c16599455.lfilter2,tp,LOCATION_DECK,0,1,c)
end
function c16599455.lfilter2(c)
	return c:IsSetCard(0x1559) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemoveAsCost()
end
function c16599455.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x1559) and re:GetHandler():GetLevel()==e:GetHandler():GetLevel() and not re:GetHandler():IsType(TYPE_SYNCHRO)
end
--target protection
function c16599455.efilter(e,re,rp)
	return ((re:GetHandler():GetLevel()>0 and re:GetHandler():IsLevelBelow(9)) or (re:GetHandler():GetRank()>0 and re:GetHandler():GetRank()<=9)) and rp==1-e:GetHandlerPlayer()
end
--spsummon procedure
function c16599455.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c16599455.cfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c16599455.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c16599455.cfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c16599455.cfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
--dual attribute
function c16599455.attribute(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local lightcount=Duel.GetMatchingGroupCount(c16599455.ctfilter,tp,LOCATION_MZONE,0,c,ATTRIBUTE_LIGHT)
	local darkcount=Duel.GetMatchingGroupCount(c16599455.ctfilter,tp,LOCATION_MZONE,0,c,ATTRIBUTE_DARK)
	return darkcount>lightcount
end
--light effect
function c16599455.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttribute(ATTRIBUTE_LIGHT)
end
function c16599455.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16599455.lfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c16599455.lfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g1:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c16599455.lfilter2,tp,LOCATION_DECK,0,1,1,g1:GetFirst())
	if g2:GetCount()<=0 then return end
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c16599455.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function c16599455.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
--dark effect
function c16599455.dgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttribute(ATTRIBUTE_DARK)
end
function c16599455.dgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetLabel()/2)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel()/2)
end
function c16599455.dgop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
--change damage
function c16599455.chgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsRace(RACE_FAIRY) and e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c16599455.chgop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_SZONE)
	e1:SetCondition(c16599455.condition)
	e1:SetOperation(c16599455.operation)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c16599455.negateval)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	--activation limit
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c16599455.aclimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c16599455.condition(e,tp,eg,ep,ev,re,r,rp)
	local att=Duel.GetAttacker()
	local def=Duel.GetAttackTarget()
	return Duel.GetBattleDamage(tp)>0 and((att:IsControler(tp) and att:IsRace(RACE_FAIRY))
		or (def:IsControler(tp) and def:IsRace(RACE_FAIRY)))
end
function c16599455.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c16599455.doubleop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c16599455.doubleop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,ev*2)
end
function c16599455.negateval(e,re,val,r,rp,rc)
	local tp=e:GetHandlerPlayer()
	if val<Duel.GetLP(tp) then
		return val
	end
	return 0
end