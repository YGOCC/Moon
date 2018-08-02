--ASSASSIN - THE WARRIOR CHIMERA
function c18591808.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,18591803,18591806,true,true)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c18591808.atkval)
	c:RegisterEffect(e1)
end
function c18591808.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x50e)
end
function c18591808.atkval(e,c)
	return Duel.GetMatchingGroupCount(c18591808.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)*200
end
