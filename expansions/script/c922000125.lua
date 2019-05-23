--Orcadragon's Flaming Assualt
local m=922000125
local cm=_G["c"..m]
local id=m
function cm.initial_effect(c)
	--(1) If a "Orcadragon" Card you control is targeted by battle or by card effect: negate that effect or attack and if you do, set that card face-down, then, all "Orcadragon" monsters you control gain 200 ATK for each card your opponent controls. If you control a "Orcadragon - Ryuko Crimson" or "Orcadragon - Ascended Ryuko Crimson"": You can activate this card from your hand, also, you can set this card face-down on the field after this effect activation. (This card cannot be activated the turn this effect is activated.)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.negcon)
	e1:SetTarget(cm.negtg)
	e1:SetOperation(cm.negop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCondition(cm.negcon2)
	e2:SetOperation(cm.negop2)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e4:SetCondition(cm.handcon)
	c:RegisterEffect(e4)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsSetCard(0x904) then return false end
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0)
end
function cm.negcon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsPosition(POS_FACEUP) and tc:IsSetCard(0x904)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		Duel.NegateActivation(ev)
		if rc:IsType(TYPE_SPELL) or rc:IsType(TYPE_TRAP) then
			rc:CancelToGrave()
		end
	end
	if Duel.ChangePosition(eg,POS_FACEDOWN)~=0 then
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
		tc=g:GetFirst()
		local atk=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)*200
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
		local g2=Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
		if g2 then
			e:GetHandler():CancelToGrave()
			Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN)
			e:GetHandler():RegisterFlagEffect(id,RESET_PHASE+PHASE_END,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e:GetHandler():RegisterEffect(e1)
		end
	end
end
function cm.negop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc:IsControler(tp) then tc=Duel.GetAttackTarget() end
	if Duel.NegateAttack() then
		if Duel.ChangePosition(tc,POS_FACEDOWN)~=0 then
			local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
			tc=g:GetFirst()
			local atk=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)*200
			while tc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(atk)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				tc=g:GetNext()
			end
			local g2=Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
			if g2 then
				e:GetHandler():CancelToGrave()
				Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN)
				e:GetHandler():RegisterFlagEffect(id,RESET_PHASE+PHASE_END,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE,1)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e:GetHandler():RegisterEffect(e1)
			end
		end
	end
end
function cm.filter(c)
	return c:IsSetCard(0x904) and c:IsType(TYPE_MONSTER)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:GetCode(id-6) or c:GetCode(id-12)
end
function cm.handcon(e)
	return Duel.IsExistingMatchingCard(cm.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
