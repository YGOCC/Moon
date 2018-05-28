--Ruins of the Fantasia Knights
--  Idea: NightcoreJack
--  Script: NightcoreJack
--[[
All "Fantasia Knight" monsters gain 500 ATK and Def. During your Main Phase, you can Normal Summon 1 "Fantasia Knight" monster in addition to your Normal Summon/Set. (You can only gain this effect once per turn.)The Normal Summon of "Fantasia Knight" monsters cannot be negated.
--]]
function c71473126.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1C1D))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--defup
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
		--extra summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e4:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1C1D))
	c:RegisterEffect(e4)
		--cannot disable summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1C1D))
	c:RegisterEffect(e5)
end
