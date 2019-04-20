--Orichalcos Effigia
function c32084021.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x7D54),4,2,nil,nil,5)
	c:EnableReviveLimit()
		--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c32084021.atkval)
	c:RegisterEffect(e1)
		--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32084021,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c32084021.damcon)
	e2:SetTarget(c32084021.damtg)
	e2:SetOperation(c32084021.damop)
	c:RegisterEffect(e2)
		--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(32084021,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c32084021.atkcost)
	e3:SetOperation(c32084021.operation)
	c:RegisterEffect(e3)
		--Orichalcos Apparatus
			--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(32084013,0))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c32084021.discon)
	e4:SetTarget(c32084021.distg)
	e4:SetOperation(c32084021.disop)
	c:RegisterEffect(e4)
			--Stone Statue of the Orichalcos
			--battle indestructable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetCondition(c32084021.distdcon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
			--change battle target
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(32084011,2))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetProperty(EFFECT_FLAG2_XMDETACH)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c32084021.cbcon)
	e6:SetCost(c32084021.cbcost)
	e6:SetOperation(c32084021.cbop)
	c:RegisterEffect(e6)
			--Orichalcos Bronze Guard
			--Immune
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_ONFIELD,0)
	e7:SetCondition(c32084021.imcon)
	e7:SetTarget(c32084021.etarget)
	e7:SetValue(c32084021.efilter)
	c:RegisterEffect(e7)
		--Cost Change
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_LPCOST_CHANGE)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetRange(LOCATION_MZONE)
	e7:SetCondition(c32084021.changecon)
	e8:SetTargetRange(1,0)
	e8:SetValue(c32084021.costchange)
	c:RegisterEffect(e8)
end
function c32084021.changecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,32084012)
end
function c32084021.costchange(e,re,rp,val)
	if re and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsType(TYPE_SPELL) or re:GetHandler():IsType(TYPE_TRAP) or re:GetHandler():IsType(TYPE_MONSTER) then
		return 0
	else
		return val
	end
end
function c32084021.imcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,32084017)
end
function c32084021.etarget(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x7D54)
end
function c32084021.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c32084021.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,2,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,nil,2,2,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c32084021.operation(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local og=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local mg,matk=og:GetMaxGroup(Card.GetAttack)
		local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_UPDATE_ATTACK)
		e7:SetReset(RESET_EVENT+0x1fe0000)
		e7:SetValue(matk+500)
		c:RegisterEffect(e7)
	end
function c32084021.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c32084021.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c32084021.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(bc)
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c32084021.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local dam=tc:GetAttack()
		if dam<0 then dam=0 end
		Duel.Damage(p,dam,REASON_EFFECT)
	end
end
function c32084021.spfilter(c,e,tp)
	return c:IsCode(32084013) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32084021.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and e:GetHandler():IsAttackPos() and ep~=tp
	and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,32084013)
end
function c32084021.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if ep==tp then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c32084021.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsPosition(POS_FACEUP_ATTACK) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	if Duel.NegateActivation(ev) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c32084021.spfilter),tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(32084013,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g1=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
end
function c32084021.distdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,32084011)
end
function c32084021.cbcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetAttackTarget()~=e:GetHandler()
	and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,32084011)
end
function c32084021.cbcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c32084021.cbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local at=Duel.GetAttacker()
		if at:IsAttackable() and not at:IsImmuneToEffect(e) then
			Duel.CalculateDamage(at,c)
		end
	end
end