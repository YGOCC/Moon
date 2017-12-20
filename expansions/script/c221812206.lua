--Viravolvesca
function c221812206.initial_effect(c)
	c:EnableReviveLimit()
	--Materials: 2 Cyberse monsters
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERS),2,2)
	--Once per turn (Quick Effect): You can target 1 of your "Viravolve" monsters; destroy it, then negate the effects of all other cards in the same column as that monster, until the End Phase.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c221812206.target)
	e2:SetOperation(c221812206.operation)
	c:RegisterEffect(e2)
end
function c221812206.cfilter(c,g)
	return g:IsContains(c) and aux.disfilter1(c)
end
function c221812206.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xa67) and c:IsDestructable()
		and Duel.IsExistingMatchingCard(c221812206.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,Group.FromCards(e:GetHandler(),c),c:GetColumnGroup())
end
function c221812206.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c221812206.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c221812206.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g:GetFirst():GetColumnGroup():Filter(aux.TRUE,Group.FromCards(c,g:GetFirst())),1,0,0)
end
function c221812206.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local vc=Duel.GetFirstTarget()
	local cg=vc:GetColumnGroup()
	if vc:IsRelateToEffect(e) and Duel.Destroy(vc,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		for tc in aux.Next(cg:Filter(Card.IsOnField,c)) do
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e3)
			end
		end
	end
end
