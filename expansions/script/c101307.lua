--Władysław, Master of Shadows
--Vladislao, Maestro de los Sombras
function c101307.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),6,2)
	c:EnableReviveLimit()
	--Negar
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101307,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c101307.negcon)
	e1:SetTarget(c101307.negtg)
	e1:SetOperation(c101307.negop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101307,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101307.negcon2)
	e2:SetTarget(c101307.negtg)
	e2:SetOperation(c101307.negop2)
	c:RegisterEffect(e2)
	--Materiales
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101307,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c101307.mttg)
	e3:SetOperation(c101307.mtop)
	c:RegisterEffect(e3)
	--Imunidad
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c101307.elimite)
	c:RegisterEffect(e4)
	--Reemplazar
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c101307.reptg)
	c:RegisterEffect(e5)
end
function c101307.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if c:GetOverlayCount()<c:GetFlagEffect(id) then return end
	return c:GetType(TYPE_MONSTER) and loc==LOCATION_MZONE and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsSetCard(0x8e)
end
function c101307.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(id,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c101307.negop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c101307.repop1)
end
function c101307.repop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and (c:IsFaceup() or c:IsFacedown()) then
		Duel.Destroy(c,REASON_EFFECT)
		Duel.Damage(tp,500,REASON_EFFECT)
	end
end
function c101307.negcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if c:GetOverlayCount()<c:GetFlagEffect(id) then return end
	return c:GetType(TYPE_MONSTER) and loc==LOCATION_GRAVE and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsSetCard(0x8e)
end
function c101307.negop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)==0 then
		Duel.NegateActivation(ev)
	end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,c101307.repop2)
	end
end
function c101307.repop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) then return end
	if c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(101307,3)) and Duel.PayLPCost(tp,1000) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENCE)
		e:GetHandler():RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_CHANGE_RACE)
		e3:SetValue(RACE_ZOMBIE)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3)
	end
end
function c101307.mtfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c101307.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101307.mtfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
end
function c101307.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c101307.mtfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c101307.elimite(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsAttribute(ATTRIBUTE_DARK) or te:GetHandler():IsRace(RACE_ZOMBIE) or
		(te:GetHandler():IsAttribute(ATTRIBUTE_DARK) and te:GetHandler():IsRace(RACE_ZOMBIE))
end
function c101307.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(101307,4)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end