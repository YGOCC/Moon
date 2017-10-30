--Toxic Tuner Token
function c90000036.initial_effect(c)
	--Synchro Limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetValue(c90000036.value1)
	c:RegisterEffect(e1)
	--Copy Name
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c90000036.condition2)
	e2:SetTarget(c90000036.target2)
	e2:SetValue(90000036)
	c:RegisterEffect(e2)
end
function c90000036.value1(e,c)
	if not c then return false end
	return not c:IsSetCard(0x14)
end
function c90000036.condition2(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c90000036.target2(e,c)
	return not c:IsSetCard(0x14)
end