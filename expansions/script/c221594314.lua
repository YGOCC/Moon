--created by Walrus, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetTarget(cid.disable)
	c:RegisterEffect(e2)
end
function cid.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xc97) and c:GetSummonLocation()==LOCATION_EXTRA
end
function cid.disable(e,c)
	local tp=e:GetHandler():GetControler()
	local g=Duel.GetMatchingGroup(cid.filter,tp,LOCATION_MZONE,0,nil)
	local typ=0
	for tc in aux.Next(g) do typ=typ|tc:GetType()&TYPE_EXTRA end
	return (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT) and #g==1 and c:GetType()&typ~=0
end
