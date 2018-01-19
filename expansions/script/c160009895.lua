--Linky Ukiki Flowey
function c160009895.initial_effect(c)
 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),2,2)
	c:EnableReviveLimit()
--ATK & DEF
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTarget(c160009895.tg1)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetTarget(c160009895.tg1)
	e2:SetValue(500)
	c:RegisterEffect(e2) 
--ATK & DEF
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(c160009895.tg2)
	e3:SetValue(-400)
	c:RegisterEffect(e3) 
local e4=e3:Clone()
e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetTarget(c160009895.tg2)
	e4:SetValue(-400)
	c:RegisterEffect(e4)	 
end
function c160009895.tg1(e,c)
	return c:IsSetCard(0x885a) or e:GetHandler()==c 
end
function c160009895.tg2(e,c)
	return not c:IsSetCard(0x885a) and not e:GetHandler()==c 
end