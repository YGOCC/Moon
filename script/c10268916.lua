--Paladins' Art: Divine Protection
function c10268916.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
		--self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c10268916.sdcon)
	c:RegisterEffect(e2)
		--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x19121))
	e3:SetValue(c10268916.indval)
	c:RegisterEffect(e3)
end
function c10268916.cfilter2(c)
	return c:IsFaceup() and c:IsCode(10268930)
end
function c10268916.sdcon(e)
	return (not Duel.IsExistingMatchingCard(c10268916.cfilter2,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and not Duel.IsEnvironment(10268930))
end
function c10268916.indval(e,re,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end