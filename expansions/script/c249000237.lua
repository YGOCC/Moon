--Gem-Caster
function c249000237.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c249000237.spcon)
	e1:SetOperation(c249000237.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(c249000237.cost)
	e2:SetTarget(c249000237.target)
	e2:SetOperation(c249000237.operation)
	c:RegisterEffect(e2)
end
function c249000237.spfilter(c)
	return c:IsSetCard(0x47) and c:IsAbleToRemoveAsCost()
end
function c249000237.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000237.spfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c249000237.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c249000237.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c249000237.costfilter(c)
	return c:IsSetCard(0x47) and c:IsDiscardable()
end
function c249000237.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000237.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c249000237.costfilter,1,1,REASON_COST+REASON_DISCARD)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c249000237.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c249000237.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c249000237.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c249000237.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetDecktopGroup(tp,1)
	local tc2=g:GetFirst()
	local typematch=false
	if tc:IsType(TYPE_MONSTER) and tc2:IsType(TYPE_MONSTER) then typematch=true end
	if tc:IsType(TYPE_SPELL) and tc2:IsType(TYPE_SPELL) then typematch=true end
	if tc:IsType(TYPE_TRAP) and tc2:IsType(TYPE_TRAP) then typematch=true end
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
		Duel.ConfirmDecktop(tp,1)	
		if typematch and tc2:IsAbleToHand() then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ShuffleHand(tp)
		else
			Duel.MoveSequence(tc,1)
		end	
	end
end