--Paintress Baconia
   local cid,id=GetID()
function cid.initial_effect(c)
--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cid.discon)
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.operation)
	c:RegisterEffect(e1)

end
function cid.cfilter(c)
	return  c:IsFaceup() and c:IsSetCard(0xc50) and c:IsType(TYPE_PENDULUM) or (c:IsType(TYPE_PENDULUM) and not c:IsType(TYPE_EFFECT)) and c:IsAbleToRemoveAsCost()
end
function cid.discon(e,tp,eg,ep,ev,re,r,rp)
return re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end

function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	 if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,c)  end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cid.cfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
   Duel.NegateEffect(ev)
end
