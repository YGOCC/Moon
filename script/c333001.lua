--Aeropolis, The Floating City
function c333001.initial_effect(c)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c333001.tg)
	e2:SetValue(c333001.val)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c333001.tglimit)
	e3:SetCondition(c333001.tgcon)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)

end
function c333001.tg(e,c)
	return c:IsSetCard(0x333) or c:IsCode(3330)
end
function c333001.filter(c)
	return c:IsFaceup() and c:IsCode(3330)
end
function c333001.val(e,c)
	return Duel.GetMatchingGroupCount(c333001.filter,c:GetControler(),LOCATION_MZONE,0,nil)*500
end

function c333001.tglimit(e,c)
	return c:IsSetCard(0x333)
end
function c333001.tgfilter(c)
	return c:IsFaceup() and c:IsCode(3330)
end
function c333001.tgcon(e)
	return Duel.IsExistingMatchingCard(c333001.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end