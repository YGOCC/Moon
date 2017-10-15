--Gemini Restrict
function c90304310.initial_effect(c)
    --activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCondition(c90304310.condition)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetTarget(c90304310.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--maintain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c90304310.mtcon)
	e3:SetOperation(c90304310.mtop)
	c:RegisterEffect(e3)
end
function c90304310.disfilter(c)
	return c:IsFaceup() and c:IsDualState()
end
function c90304310.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c90304310.disfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c90304310.disable(e,c)
	return c:IsType(TYPE_XYZ+TYPE_SYNCHRO+TYPE_FUSION) --or bit.band(c:GetOriginalType(),TYPE_EFFECT)== TYPE_EFFECT
end
function c90304310.mtcon(e,tp,eg,ep,ev,re,r,rp)--maintain functions
	return Duel.GetTurnPlayer()==tp
end
function c90304310.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,3000) and Duel.SelectYesNo(tp,aux.Stringid(90304310,0)) then
		Duel.PayLPCost(tp,3000)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
