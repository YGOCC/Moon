--Paintress Warholee
function c160008746.initial_effect(c)
	   --cannot be battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c160008746.bttg)
	c:RegisterEffect(e1)
 --extra summon
	   local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_DUAL))
	e3:SetTargetRange(1,0)
	e3:SetValue(2)
	c:RegisterEffect(e3)
end
function c160008746.bttg(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsSetCard(0xc50) or not c:IsType(TYPE_EFFECT)
end