--A.O. Nexus
function c21730411.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c21730411.cost)
	c:RegisterEffect(e1)
	--can activate trap the turn it was set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21730411,0))
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
function c21730411.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(21730411,RESET_CHAIN,0,1)
end