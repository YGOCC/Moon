--A.O. Nexus
function c21730412.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c21730412.cost)
	c:RegisterEffect(e1)
	--activate "a.o." traps the turn they were set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21730412,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x719))
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
end
--activate
function c21730412.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(21730412,RESET_CHAIN,0,1)
end
