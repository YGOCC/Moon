--Mystic Wand
function c90000063.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--ATK X2
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c90000063.condition1)
	e1:SetOperation(c90000063.operation1)
	c:RegisterEffect(e1)
end
function c90000063.filter1(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c90000063.condition1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	if not b then return false end
	if a:IsControler(1-tp) then a,b=b,a end
	return a:IsSetCard(0x2d) and a:IsRelateToBattle() and Duel.IsExistingMatchingCard(c90000063.filter1,tp,LOCATION_MZONE,0,1,a,a:GetCode())
end
function c90000063.operation1(e,tp,eg,ep,ev,re,r,rp,chk)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,b=b,a end
	if a:IsRelateToBattle() and a:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(a:GetAttack()*2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		a:RegisterEffect(e1)
	end
end