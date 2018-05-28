--Pandemoniumgraph of Supermacy
function c902763443.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--During your Main Phase: You can Set 1 face-up "Pandemoniumgraph" Pandemonium Monster from your Extra Deck into your Spell/Trap Zone, and if you do, it can be activated this turn. Until the end of the turn you activated this effect, negate the Pandemonium Effects of monsters with the same name as that target. (HOPT1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,902763443)
	e1:SetTarget(c902763443.thtg)
	e1:SetOperation(c902763443.thop)
	c:RegisterEffect(e1)
	--If a "Pandemoniumgraph" card in your Pandemonium Zone is destroyed by your opponent's card effect: You can add 1 Pandemonium Monster from your Deck to your Hand. (HOPT2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,902763444)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetCondition(c902763443.spcon)
	e2:SetTarget(c902763443.sptg)
	e2:SetOperation(c902763443.spop)
	c:RegisterEffect(e2)
end
function c902763443.thfilter(c)
	return (c:IsFaceup() and c:IsType(TYPE_PANDEMONIUM)) and c:IsSetCard(0xcf80)
end
function c902763443.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c902763443.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c902763443.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,1601)
	local g=Duel.SelectMatchingCard(tp,c902763443.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		aux.PandSSet(g,REASON_EFFECT)(e,tp,eg,ep,ev,re,r,rp)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
		e1:SetTarget(c902763443.distg)
		e1:SetLabel(tc:GetOriginalCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c902763443.discon)
		e2:SetOperation(c902763443.disop)
		e2:SetLabel(tc:GetOriginalCode())
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c902763443.distg(e,c)
	local code=e:GetLabel()
	local code1,code2=c:GetOriginalCodeRule()
	return code1==code or code2==code
end
function c902763443.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return re:IsActiveType(TYPE_TRAP) and (code1==code or code2==code)
end
function c902763443.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c902763443.cfilter(c,tp)
	return c:IsSetCard(0xcf80) and c:GetPreviousTypeOnField()&TYPE_PANDEMONIUM==TYPE_PANDEMONIUM and c:IsPreviousLocation(LOCATION_SZONE)
		and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_EFFECT)
end
function c902763443.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and eg:IsExists(c902763443.cfilter,1,nil,tp)
end
function c902763443.filter(c)
	return c:IsType(TYPE_PANDEMONIUM) and c:IsAbleToHand()
end
function c902763443.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c902763443.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c902763443.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c902763443.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
