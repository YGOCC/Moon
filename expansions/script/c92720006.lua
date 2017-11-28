--Chronowitch Diablo
function c92720006.initial_effect(c)
	c:EnableCounterPermit(0x2)
	--link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),2)
	--attackup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(c92720006.attackup)
    c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c92720006.target)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c92720006.targt)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c92720006.attackup(e,c)
    return c:GetCounter(0x2)*200
end
function c92720006.target(e,c)
	return c:IsSetCard(0xf92) and c:IsType(TYPE_MONSTER) and c:GetCounter(0x2)>=2
end
function c92720006.targt(e,c)
	return c:IsSetCard(0xf92) and c:IsType(TYPE_MONSTER) and c:GetCounter(0x2)>=2
end
