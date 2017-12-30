--Headshot
function c51464506.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c51464506.cost)
	e1:SetTarget(c51464506.target)
	e1:SetOperation(c51464506.activate)
	c:RegisterEffect(e1)
end
function c51464506.filter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:GetSummonPlayer()==tp and c:IsAbleToRemove() and not c:IsDisabled()
end
function c51464506.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x85,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x85,2,REASON_COST)
end
function c51464506.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return eg:IsExists(c51464506.filter,1,nil,1-tp) end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(c51464506.filter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c51464506.filter2(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
		and c:GetSummonPlayer()==tp and c:IsAbleToRemove() and c:IsRelateToEffect(e)
end
function c51464506.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c51464506.filter2,nil,e,1-tp)
	local tc=g:GetFirst()
	if not tc then return end
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	if not tc:IsDisabled() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
	local rg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_REMOVED) then
			local g1=nil
			local tpe=tc:GetType()
				if bit.band(tpe,TYPE_TOKEN)~=0 then
			else
				g1=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_DECK+LOCATION_HAND,nil,tc:GetCode())
				rg:Merge(g1)
			end
		end
		tc=g:GetNext()
	end
	if rg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
