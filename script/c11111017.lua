--Geradin, the Original Skydian
function c11111017.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c11111017.mfilter,3,3)
	--(This card is also always LIGHT and EARTH-Attribute.)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_LIGHT+ATTRIBUTE_EARTH)
	c:RegisterEffect(e1)
	--Must first be Link Summoned.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c11111017.splimit)
	c:RegisterEffect(e2)
	--Cannot be targeted by card effects.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--While this card is co-linked, this card can attack all monsters your opponent controls, once each.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	e4:SetCondition(function(e) return e:GetHandler():GetMutualLinkedGroupCount()>0 end)
	c:RegisterEffect(e4)
end
function c11111017.mfilter(c)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x223)
end
function c11111017.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
