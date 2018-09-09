--Scriba dell'Organizzazione Angeli, Nesto
--Script by XGlitchy30
function c16599459.initial_effect(c)
	--target protection
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(c16599459.efilter)
	c:RegisterEffect(e0)
	--dual attribute
	local e0x=Effect.CreateEffect(c)
	e0x:SetType(EFFECT_TYPE_SINGLE)
	e0x:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0x:SetRange(LOCATION_DECK)
	e0x:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0x:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e0x)
	--synchro limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c16599459.synlimit)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,16599459)
	e2:SetLabel(0)
	e2:SetCondition(c16599459.drawcon)
	e2:SetCost(c16599459.drawcost)
	e2:SetTarget(c16599459.drawtg)
	e2:SetOperation(c16599459.drawop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(c16599459.thcon)
	e3:SetTarget(c16599459.thtg)
	e3:SetOperation(c16599459.thop)
	c:RegisterEffect(e3)
	--Register Damage
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	ge0:SetCode(EVENT_DAMAGE)
	ge0:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_SZONE)
	ge0:SetLabelObject(e2)
	ge0:SetCondition(c16599459.regcon)
	ge0:SetOperation(c16599459.register)
	c:RegisterEffect(ge0)
	--Reset Damage
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	ge1:SetCode(EVENT_TURN_END)
	ge1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_SZONE)
	ge1:SetCountLimit(1)
	ge1:SetLabelObject(e2)
	ge1:SetCondition(c16599459.resetcon)
	ge1:SetOperation(c16599459.reset)
	c:RegisterEffect(ge1)
end
-----Register Damage-----
function c16599459.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local att=Duel.GetAttacker()
	local def=Duel.GetAttackTarget()
	return att and def and ep==tp and bit.band(r,REASON_BATTLE)~=0
		and ((att:IsControler(tp) and att:IsRace(RACE_FAIRY))
		or (def:IsControler(tp) and def:IsRace(RACE_FAIRY)))
end
function c16599459.register(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(101)
end
-----Reset Damage-----
function c16599459.resetcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()>0
end
function c16599459.reset(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
end
--filters
function c16599459.cfilter(c,lv)
	return c:IsSetCard(0x1559) and c:GetLevel()>lv and c:IsAbleToRemoveAsCost()
end
function c16599459.eqfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and c:GetAttack()==0
end
function c16599459.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c16599459.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x1559) and re:GetHandler():GetLevel()==e:GetHandler():GetLevel() and not re:GetHandler():IsType(TYPE_SYNCHRO)
end
function c16599459.eq(c,card)
	return c==card
end
--target protection
function c16599459.efilter(e,re,rp)
	return ((re:GetHandler():GetLevel()>0 and re:GetHandler():IsLevelBelow(5)) or (re:GetHandler():GetRank()>0 and re:GetHandler():GetRank()<=5)) and rp==1-e:GetHandlerPlayer()
end
--synchro limit
function c16599459.synlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_FAIRY)
end
--draw
function c16599459.drawcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==101
end
function c16599459.drawcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c16599459.cfilter,tp,LOCATION_DECK,0,1,c,c:GetLevel())
		and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_DECK,0,nil)-1>0
	end
	local rg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c16599459.cfilter,tp,LOCATION_DECK,0,1,1,c,c:GetLevel())
	rg:AddCard(c)
	rg:AddCard(g:GetFirst())
	if rg:GetCount()==2 then
		Duel.Remove(rg,POS_FACEUP,REASON_COST)
	end
end
function c16599459.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c16599459.drawop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--equip
function c16599459.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsRace(RACE_FAIRY) and e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c16599459.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and c16599459.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c16599459.eqfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c16599459.eqfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c16599459.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or c:IsFacedown() or tc:IsFacedown() then return end
	Duel.Equip(tp,c,tc)
	--equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(c16599459.eqlimit)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	--tuner state
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(TYPE_TUNER)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
	--activation limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c16599459.aclimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
--tuner state
function c16599459.tunercon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c16599459.eq,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e:GetHandler():GetEquipTarget())
end
function c16599459.tunertg(e,c)
	return c==e:GetHandler():GetEquipTarget()
end