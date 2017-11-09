--Bushido Dog
function c1020049.initial_effect(c)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c1020049.tgval)
	c:RegisterEffect(e1)
	--NS/Monster Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1020049,0))
	e1:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,1020049)
	e2:SetTarget(c1020049.tdtg)
	e2:SetOperation(c1020049.tdop)
	c:RegisterEffect(e2)
	--Banish/Spell/Trap Search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,1020049)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(c1020049.regop)
	c:RegisterEffect(e3)
end
function c1020049.tgval(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsControler(1-e:GetHandlerPlayer()) and re:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
		and re:GetHandler():IsLocation(LOCATION_MZONE)
end
function c1020049.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x4B0) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c1020049.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function c1020049.cfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x4B0) and c:IsType(TYPE_MONSTER)
end
function c1020049.tdop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c1020049.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1020049.filter,tp,LOCATION_REMOVED,0,1,ct,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c1020049.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x4B0))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
