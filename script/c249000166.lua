--Dark Burial Warlock
function c249000166.initial_effect(c)
	--to grave, discarding a monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(70)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,249000166)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c249000166.sgcost)
	e1:SetTarget(c249000166.sgtg)
	e1:SetOperation(c249000166.sgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(71)
	e2:SetCost(c249000166.sgcost2)
	e2:SetTarget(c249000166.sgtg2)
	e2:SetOperation(c249000166.sgop2)
	c:RegisterEffect(e2)
end
function c249000166.costfilter(c)
	return c:IsDiscardable() and c:IsType(TYPE_MONSTER)
end
function c249000166.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000166.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c249000166.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c249000166.filter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToGrave()
end
function c249000166.sgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c249000166.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c249000166.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c249000166.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then 
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c249000166.costfilter2(c)
	return c:IsDiscardable() and not c:IsType(TYPE_MONSTER)
end
function c249000166.sgcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000166.costfilter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c249000166.costfilter2,1,1,REASON_COST+REASON_DISCARD)
end
function c249000166.sgtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c249000166.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function c249000166.sgop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c249000166.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then 
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	local dg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE+LOCATION_SZONE,nil)
	if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(28553439,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local des=dg:Select(tp,1,1,nil)
		Duel.HintSelection(des)
		Duel.BreakEffect()
		Duel.Destroy(des,REASON_EFFECT)
	end
end
