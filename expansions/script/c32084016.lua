--Orichalcos Mos-Ignius
function c32084016.initial_effect(c)
	c:SetSPSummonOnce(32084016)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x7D54),3,false)
		--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c32084016.atkval)
	c:RegisterEffect(e1)
		--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c32084016.aclimit)
	e2:SetCondition(c32084016.actcon)
	c:RegisterEffect(e2)
		--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32084016,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c32084016.discon)
	e1:SetCost(c32084016.discost)
	e1:SetTarget(c32084016.distg)
	e1:SetOperation(c32084016.disop)
	c:RegisterEffect(e1)
end
function c32084016.atkval(e,c)
	return Duel.GetFieldGroupCount(0,LOCATION_ONFIELD,LOCATION_ONFIELD)*400
end
function c32084016.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c32084016.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function c32084016.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return rp~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c32084016.costfilter(c)
	return c:IsSetCard(0x7D54) and not c:IsPublic()
end
function c32084016.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32084016.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c32084016.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c32084016.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c32084016.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

