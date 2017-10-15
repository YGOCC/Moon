--Operation - Teleporter
function c90000058.initial_effect(c)
	--Pendulum Set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90000058,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c90000058.cost)
	e1:SetTarget(c90000058.target)
	e1:SetOperation(c90000058.operation)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90000058,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c90000058.cost)
	e2:SetTarget(c90000058.target2)
	e2:SetOperation(c90000058.operation2)
	c:RegisterEffect(e2)
end
function c90000058.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c90000058.filter(c)
	return c:IsSetCard(0x1c) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c90000058.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7))
		and Duel.IsExistingMatchingCard(c90000058.filter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,nil) end
end
function c90000058.operation(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c90000058.filter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c90000058.filter2(c,e,tp)
	return c:IsSetCard(0x1c) and c:IsType(TYPE_PENDULUM) and ((c:GetSequence()==6 or c:GetSequence()==7)
		or (c:IsFaceup() and c:IsLocation(LOCATION_EXTRA))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90000058.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c90000058.filter2,tp,LOCATION_SZONE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE+LOCATION_EXTRA)
end
function c90000058.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c90000058.filter2,tp,LOCATION_SZONE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end