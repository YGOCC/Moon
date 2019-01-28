--Arcrise Guardian
local ref=_G['c'..28915119]
local id=28915119
function ref.initial_effect(c)
	--Evolute Summon
	c:SetSPSummonOnce(id)
	aux.AddOrigEvoluteType(c)
	c:EnableReviveLimit()
	aux.AddEvoluteProc(c,'Convergent',0,ref.matfilter1,ref.matfilter2,2,99)
	--ATK+Protect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(ref.atkcost)
	e1:SetTarget(ref.atktg)
	e1:SetOperation(ref.atkop)
	c:RegisterEffect(e1)
	--Protection
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(ref.ndscon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(ref.ndstg)
	e2:SetOperation(ref.ndsop)
	c:RegisterEffect(e2)
end
function ref.matfilter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_WIND)
end
function ref.matfilter2(c,ec,tp)
	return c:IsType(TYPE_PENDULUM)
end

--Draw+ATK
function ref.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveEC(tp,3,REASON_COST) end
	c:RemoveEC(tp,3,REASON_COST)
end
function ref.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function ref.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_UPDATE_ATTACK)
		e0:SetValue(400)
		e0:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e0)
		if Duel.GetFlagEffect(tp,id)==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(aux.TRUE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(ref.efilter)
			Duel.RegisterEffect(e1,tp)
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,1,0)
		end
	end
end
function ref.efilter(e,re)
	return e:GetHandler()~=re:GetOwner() and not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) --and bit.band(r,REASON_EFFECT)~=0
end

--Protection
function ref.ndscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,1600000000)~=0
end
function ref.ndstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function ref.ndsop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_PZONE,0)
	e1:SetTarget(aux.TRUE)
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
