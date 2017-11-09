--Bushido God Behemoth
function c1020052.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c1020052.unval)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c1020052.indcon)
	e2:SetOperation(c1020052.indop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c1020052.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--def attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(3429238,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c1020052.datcon)
	e4:SetCost(c1020052.datcost)
	e4:SetTarget(c1020052.dattg)
	e4:SetOperation(c1020052.datop)
	c:RegisterEffect(e4,false,1)
end
function c1020052.unval(e,re)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsControler(1-e:GetHandlerPlayer()) and re:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
		and re:GetHandler():IsLocation(LOCATION_MZONE)
end
function c1020052.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,2,nil,0x4B0) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c1020052.indcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetLabel()==1
end
function c1020052.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c1020052.datcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c1020052.datcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c1020052.ftarget)
	e1:SetLabel(e:GetHandler():GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c1020052.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c1020052.dattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsHasEffect(EFFECT_DEFENSE_ATTACK) end
end
function c1020052.datop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DEFENSE_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
