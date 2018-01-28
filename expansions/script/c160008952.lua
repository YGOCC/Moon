--Paintress' Sketchbook
function c160008952.initial_effect(c)
   local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c160008952.condition)
	e2:SetCost(c160008952.discost)
	e2:SetOperation(c160008952.disop)
	c:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c160008952.tgcon)
	e3:SetOperation(c160008952.tgop)
	c:RegisterEffect(e3)
end
function c160008952.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and ph==PHASE_MAIN1
end
function c160008952.cfilter(c)
	return c:IsSetCard(0xc50) or c:GetType()==TYPE_MONSTER+TYPE_NORMAL
end
function c160008952.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c160008952.cfilter,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,c160008952.cfilter,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c160008952.disop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c160008952.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c160008952.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(TYPE_EFFECT)
end
function c160008952.sdfilter(c)
	return  c:IsType(TYPE_NORMAL)
end

function c160008952.tgcon(e)
	return not Duel.IsExistingMatchingCard(c160008952.sdfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c160008952.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end