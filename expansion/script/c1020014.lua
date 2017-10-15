function c1020014.initial_effect(c)
	c:SetUniqueOnField(1,0,1020014)
	--synchro summon
	aux.AddSynchroProcedure(c,c1020014.tunfil,aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c1020014.val)
	c:RegisterEffect(e1)
	--selfdestroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c1020014.descon)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c1020014.imfilter)
	c:RegisterEffect(e3)
end
function c1020014.tunfil(c)
	return c:IsRace(RACE_MACHINE) and c:GetLevel()==3
end
function c1020014.val(c)
	return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)*200
end
function c1020014.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1ded) and c:IsType(TYPE_MONSTER)
end
function c1020014.descon(e)
	return not Duel.IsExistingMatchingCard(c1020014.desfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c1020014.imfilter(e,te)
	local c=te
	return (c:IsActiveType(TYPE_FUSION) or c:IsActiveType(TYPE_SYNCHRO) or c:IsActiveType(TYPE_XYZ))
		and te:GetOwner()~=e:GetOwner()
end
