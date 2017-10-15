--Start Shrine
function c4103.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,4103+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c4103.condition)
	e1:SetTarget(c4103.target)
	e1:SetOperation(c4103.activate)
	c:RegisterEffect(e1)
		--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4103,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c4103.negcon)
	e2:SetCost(c4103.negcost)
	e2:SetOperation(c4103.activate2)
	c:RegisterEffect(e2)
end
function c4103.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x10041036)
end
function c4103.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return not Duel.IsExistingMatchingCard(c4103.cfilter,tp,LOCATION_MZONE,0,1,nil) 
	or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c4103.filter2(c,e,tp)
	return c:IsSetCard(0x1004101D) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4103.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c4103.filter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c4103.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c4103.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c4103.negfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1004101D)
end
function c4103.negcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and Duel.IsExistingMatchingCard(c4103.negfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c4103.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c4103.filter3(c)
	return c:IsFaceup() and c:IsSetCard(0x1004101D)
end
function c4103.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c4103.filter3,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1004101D))
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(c4103.efilter)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c4103.efilter(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end