--Supreme Enemy of the Ripple Warrior
function c11528782.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c11528782.mfilter,6,3,c11528782.ovfilter,aux.Stringid(11528782,0),3,c11528782.xyzop)
	c:EnableReviveLimit()
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11528782,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c11528782.mttg)
	e1:SetOperation(c11528782.mtop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG2_XMDETACH+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c11528782.discon)
	e2:SetCost(c11528782.discost)
	e2:SetTarget(c11528782.distg)
	e2:SetOperation(c11528782.disop)
	c:RegisterEffect(e2)
end
function c11528782.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c11528782.ovfilter(c)
	return c:IsFaceup() and c:IsCode(11528793)
end
function c11528782.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,11528782)==0 end
	Duel.RegisterFlagEffect(tp,11528782,RESET_PHASE+PHASE_END,0,1)
end
function c11528782.mtfilter(c)
	return c:IsSetCard(0x806)
end
function c11528782.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11528782.mtfilter,tp,LOCATION_HAND,0,1,nil) end
end
function c11528782.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c11528782.mtfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c11528782.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c11528782.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11528782.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c11528782.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
