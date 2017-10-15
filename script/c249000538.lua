--Synchro-Converter Field Commander
function c249000538.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SYNCHRO))
	e1:SetValue(600)
	c:RegisterEffect(e1)
	--lv up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetValue(c249000538.lvval)
	c:RegisterEffect(e2)
end
function c249000538.lvval(e,c)
	local lv=e:GetHandler():GetLevel()
	if lv<=2 then return 1 end
	return lv-2
end
