--Mysterious Ball
function c53313903.initial_effect(c)
	--multi attack
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetDescription(aux.Stringid(53313903,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c53313903.distg)
	e1:SetOperation(c53313903.disop)
	c:RegisterEffect(e1)
end
function c53313903.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,5)
end
function c53313903.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsType,nil,TYPE_MONSTER)
		if ct>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EXTRA_ATTACK)
			e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
			e1:SetValue(ct-1)
			c:RegisterEffect(e1)
		end
	end
end
