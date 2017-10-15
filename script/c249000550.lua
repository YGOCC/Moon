--Overlution Battle Mage
function c249000550.initial_effect(c)
	--to defense
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetCondition(c249000550.poscon)
	e1:SetOperation(c249000550.posop)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72502414,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c249000550.condition)
	e2:SetTarget(c249000550.target)
	e2:SetOperation(c249000550.operation)
	c:RegisterEffect(e2)
end
function c249000550.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() and e:GetHandler():IsRelateToBattle()
end
function c249000550.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
function c249000550.cfilter(c,code)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x1CC) and c:GetCode()~=code
end
function c249000550.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000550.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,e:GetHandler():GetCode())
end
function c249000550.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c249000550.filter2(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c249000550.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c249000550.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000550.filter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingTarget(c249000550.filter2,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c249000550.filter,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	local g1=Duel.SelectTarget(tp,c249000550.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c249000550.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc2=g:GetFirst()
	if tc1==tc2 then tc2=g:GetNext() end
	if c:IsRelateToEffect(e) and tc1:IsRelateToEffect(e) and not tc1:IsImmuneToEffect(e) then
		Duel.Overlay(tc1,Group.FromCards(c))
	end
	if tc2:IsRelateToEffect(e) then
		Duel.Destroy(tc2,REASON_EFFECT)
	end
end
