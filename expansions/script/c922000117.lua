--Orcadragon - Mami
local m=922000117
local cm=_G["c"..m]
local id=m
function cm.initial_effect(c)
	--(1) You can special summon this card when only you control a monster.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
	--(2) This card gains 200 DEF for each "Orcadragon" monster you control.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
end
--(1)
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)==0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
--(2)

function cm.atkfilter(c)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x904)
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.atkfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)*200
end