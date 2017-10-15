--Overlay-Evolve MT Absorbtion
function c249000621.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c249000621.condition)
	e1:SetTarget(c249000621.target)
	e1:SetOperation(c249000621.activate)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19310321,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c249000621.cost)
	e2:SetTarget(c249000621.target2)
	e2:SetOperation(c249000621.operation2)
	c:RegisterEffect(e2)
end
function c249000621.confilter(c)
	return c:IsSetCard(0x1D8) and c:IsFaceup()
end
function c249000621.condition(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or (not Duel.IsExistingMatchingCard(c249000621.confilter,tp,LOCATION_ONFIELD,0,2,nil)) then return false end
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c249000621.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)
	if re:GetHandler():IsAbleToGrave() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,1,0,0)
	end
end
function c249000621.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	Duel.Recover(tp,800,REASON_EFFECT)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoGrave(eg,REASON_EFFECT)
	end
end
function c249000621.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c249000621.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c249000621.filter2(c)
	return c:IsSetCard(0x1D8)
end
function c249000621.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c249000621.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c249000621.filter2,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19310321,1))
	local g1=Duel.SelectTarget(tp,c249000621.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19310321,2))
	local g2=Duel.SelectTarget(tp,c249000621.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g2,1,0,0)
end
function c249000621.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,tc,e)
	if g:GetCount()>0 then
		Duel.Overlay(tc,g)
	end
end