--Bringer of Justice
function c10268936.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c10268936.tfilter,aux.NonTuner(Card.IsSetCard,0x19121),1)
	c:EnableReviveLimit()
		--attack all
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
		--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c10268936.indes)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c10268936.tfilter(c)
	return c:IsSetCard(0x19121)
end
function c10268936.indes(e,c)
	return c:IsCode(10268930)
end 