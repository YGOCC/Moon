--Secret-Rites Treasure
function c249000758.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,249000758)
	e1:SetCondition(c249000758.condition)
	e1:SetCost(c249000758.cost)
	e1:SetTarget(c249000758.target)
	e1:SetOperation(c249000758.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(249000758,ACTIVITY_SPSUMMON,c249000758.counterfilter)
end
function c249000758.counterfilter(c)
	return c:IsType(TYPE_XYZ) or c:IsSetCard(0x1EF)
end
function c249000758.confilter(c)
	return c:IsSetCard(0x1EF) and c:IsType(TYPE_MONSTER)
end
function c249000758.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000758.confilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c249000758.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(249000758,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c249000758.splimit)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c249000758.splimit(e,c)
	return not (c:IsSetCard(0x1EF) or c:IsType(TYPE_XYZ))
end
function c249000758.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c249000758.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,2,REASON_EFFECT)
end
