--Supervisore del Destino
--Script by XGlitchy30
function c39759370.initial_effect(c)
	--Deck Master
	aux.AddOrigDeckmasterType(c)
	aux.EnableDeckmaster(c,nil,nil,c39759370.mscon,c39759370.mscustom,c39759370.penaltycon,c39759370.penalty)
	--Ability: Course Deviation
	local ab=Effect.CreateEffect(c)
	ab:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	ab:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ab:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	ab:SetRange(LOCATION_SZONE)
	ab:SetCountLimit(1,39759370)
	ab:SetCondition(c39759370.lkcon)
	ab:SetOperation(c39759370.lkop)
	c:RegisterEffect(ab)
end
--filters
function c39759370.thfilter(c)
	return c:IsAbleToHand() and c:GetFlagEffect(39759370)~=0
end
--Deck Master Functions
function c39759370.DMCost(e,tp,eg,ep,ev,re,r,rp)
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAINING)
	e0:SetOperation(c39759370.chainop)
	Duel.RegisterEffect(e0,tp)
end
function c39759370.chainop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then
		Duel.SetChainLimit(c39759370.chainlm)
	end
end
function c39759370.chainlm(e,rp,tp)
	return tp~=rp
end
function c39759370.mscon(e,c)
	local rg=Duel.GetDecktopGroup(tp,6)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and rg:FilterCount(Card.IsAbleToRemoveAsCost,nil)==6
end
function c39759370.mscustom(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetDecktopGroup(tp,6)
	if #g<6 then return end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c39759370.penaltycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c39759370.thfilter,tp,0,LOCATION_DECK,1,nil)
end
function c39759370.penalty(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c39759370.thfilter,tp,0,LOCATION_DECK,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,1-tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,g)
	end
end
--Ability: Course Deviation
function c39759370.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.CheckDMActivatedState(e) and Duel.GetTurnPlayer()==1-tp and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0
end
function c39759370.lkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,1)
	Duel.ConfirmCards(tp,g)
	local tc=g:GetFirst()
	if tc:IsAbleToRemove() then
		if Duel.SelectYesNo(tp,aux.Stringid(39759370,2)) then
			if Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)~=0 then
				tc:RegisterFlagEffect(39759370,RESET_EVENT+EVENT_CUSTOM+1010,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE,1)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
				e1:SetRange(LOCATION_REMOVED)
				e1:SetCountLimit(1)
				e1:SetLabel(e:GetHandler():GetControler())
				e1:SetCondition(c39759370.tdcon)
				e1:SetOperation(c39759370.tdop)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,3)
				tc:RegisterEffect(e1,true)
			end
		end
	end
end
function c39759370.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==e:GetLabel() and e:GetHandler():IsFacedown()
end
function c39759370.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end