--Skill Learner's Calling Art
function c249001002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c249001002.condition)
	e1:SetTarget(c249001002.target)
	e1:SetOperation(c249001002.activate)
	c:RegisterEffect(e1)
end
function c249001002.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1B2)
end
function c249001002.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249001002.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c249001002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0,nil)>0 then
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_DECK)
end
function c249001002.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	local g=Duel.GetDecktopGroup(tp,2)
	Duel.DisableShuffleCheck()
	if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)<1 then return end
	local g2=g:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	local tc=g2:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetOperation(c249001002.thop)
		tc:RegisterEffect(e1)
		tc=g2:GetNext()
	end
end
function c249001002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
