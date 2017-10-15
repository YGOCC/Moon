--Wakka
function c20386005.initial_effect(c)
	c:EnableCounterPermit(0x94b)
				--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c20386005.ccon)
	e1:SetOperation(c20386005.cop)
	c:RegisterEffect(e1)
	--untargetable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c20386005.target)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(c20386005.val)
	c:RegisterEffect(e3)
		--overdrive - multi attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(20386005,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c20386005.mcost)
	e4:SetOperation(c20386005.mtop)
	c:RegisterEffect(e4)
end
function c20386005.target(e,c)
	return c~=e:GetHandler() and c:IsSetCard(0x31C55) or c:IsCode(20386000)
end
function c20386005.val(e,re,rp)
	return rp~=e:GetOwnerPlayer()
end
function c20386005.ccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function c20386005.cop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x94b,1)
end
function c20386005.mcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x94b)>0 end
	local ct=e:GetHandler():GetCounter(0x94b)
	e:SetLabel(ct*1)
	e:GetHandler():RemoveCounter(tp,0x94b,ct,REASON_COST)
end
function c20386005.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local val=e:GetLabel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(val-1)
		c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c20386005.condition)
	e2:SetOperation(c20386005.operation)
	c:RegisterEffect(e2)
end
end
function c20386005.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function c20386005.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local n=c:GetCounter(0x94b)
	if n~=0 then c:RemoveCounter(tp,0x94b,n,REASON_EFFECT) end
end