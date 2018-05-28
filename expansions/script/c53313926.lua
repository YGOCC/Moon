--Mysterious Cluster Dragon
function c53313926.initial_effect(c)
	aux.AddOrigPandemoniumType(c)
	--P: When a card you control is destroyed by your opponent's card (by battle or by card effect): you can destroy this card and destroy all monsters your opponent controls.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCondition(c53313926.descon)
	e1:SetTarget(c53313926.destg)
	e1:SetOperation(c53313926.desop)
	c:RegisterEffect(e1)
	aux.EnablePandemoniumAttribute(c,e1,false,TYPE_EFFECT+TYPE_XYZ)
	--Materials: 4 level 9 monsters
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,9,4)
	--M: Once Per Turn (Quick Effect): You can detach 1 Xyz Material from this card, target 1 monster on the field, halve its ATK and negate its effects.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e2:SetDescription(1131)
	e2:SetCondition(c53313926.condition)
	e2:SetCost(c53313926.cost)
	e2:SetTarget(c53313926.target)
	e2:SetOperation(c53313926.activate)
	c:RegisterEffect(e2)
	--M: Once per turn: you can tribute 1 monster you control, to choose 1 monster on the field, its ATK becomes 0.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetDescription(1113)
	e3:SetCost(c53313926.atkcost)
	e3:SetOperation(c53313926.atkop)
	c:RegisterEffect(e3)
	--M: when this card is destroyed you can activate this card in your Spell/Trap card zone.
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetTarget(aux.PandActCon)
	e7:SetOperation(c53313926.penop)
	c:RegisterEffect(e7)
end
--If you can Pendulum/Pandemonium summon level 9 monsters you can Pendulum/Pandemonium summon this face-up card from your Extra Deck.
c53313926.pendulum_level=9
c53313926.pandemonium_level=9
function c53313926.spcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetReasonPlayer()~=tp
end
function c53313926.descon(e,tp,eg,ep,ev,re,r,rp)
	return aux.PandActCheck(e) and eg:IsExists(c53313926.spcfilter,1,nil,tp)
end
function c53313926.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if chk==0 then return c:IsDestructable() and g:GetCount()>0 end
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c53313926.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if not c:IsRelateToEffect(e) or g:GetCount()==0 or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	Duel.Destroy(g,REASON_EFFECT)
end
function c53313926.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c53313926.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c53313926.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c53313926.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_SET_ATTACK)
		e3:SetValue(tc:GetAttack()/2)
		tc:RegisterEffect(e3)
	end
end
function c53313926.cfilter(c,tp)
	return c:IsControler(tp) and Duel.IsExistingMatchingCard(c53313926.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c53313926.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c53313926.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c53313926.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c53313926.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c53313926.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c53313926.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c53313926.penop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(aux.PaCheckFilter,tp,LOCATION_SZONE,0,1,e:GetHandler()) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
