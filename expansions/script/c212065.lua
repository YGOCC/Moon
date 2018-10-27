--Harpie's Vicious Dragon
function c212065.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c212065.mfilter,7,2,c212065.ovfilter,aux.Stringid(212065,0),2,c212065.xyzop)
	c:EnableReviveLimit()
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c212065.val)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--indes by effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x64))
	e3:SetValue(3)
	c:RegisterEffect(e3)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(212065,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c212065.discon)
	e1:SetCost(c212065.discost)
	e1:SetTarget(c212065.distg)
	e1:SetOperation(c212065.disop)
	c:RegisterEffect(e1)
end
function c212065.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND)
end
function c212065.ovfilter(c)
	return c:IsFaceup() and c:IsCode(52040216)
end
function c212065.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,212065)==0 end
	Duel.RegisterFlagEffect(tp,212065,RESET_PHASE+PHASE_END,0,1)
end
function c212065.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x64)
end
function c212065.val(e,c)
	return Duel.GetMatchingGroupCount(c212065.filter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*200
end
function c212065.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return rp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c212065.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c212065.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c212065.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end