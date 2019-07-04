--A.O. Nexus (Bug Test)
--By Auramram
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--set turn activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetCondition(s.condition)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x719))
	c:RegisterEffect(e2)
	--replace tribute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(id)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
end
--set turn activate
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x719) and c:IsType(TYPE_TRAP)
end
function s.condition(e)
	local tp=e:GetHandler():GetControler()
	return Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_SZONE,0,nil)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end
