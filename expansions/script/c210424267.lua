--Moon Burst's Reaction
local card = c210424267
function card.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(card.prottg)
	e1:SetOperation(card.protop)
	c:RegisterEffect(e1)
	--move card to scale
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(card.scon)
	e2:SetCost(card.sc)
	e2:SetTarget(card.stg)
	e2:SetOperation(card.sop)
	c:RegisterEffect(e2)
end
function card.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x666) and not c:IsForbidden()
end
function card.disfilter(c)
	return c:IsAbleToGraveAsCost()
end
function card.scon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetTurnCount()~=e:GetHandler():GetTurnID() or e:GetHandler():IsReason(REASON_RETURN) 
	and Duel.IsExistingMatchingCard(card.filter,tp,LOCATION_DECK,0,1,nil)
end
function card.sc(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()  and Duel.IsExistingMatchingCard(card.disfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)

end
function card.sfilter(c,tpe)
	return c:IsSetCard(0x666) and c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function card.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tpe=e:GetLabel()
	if chk==0 then return Duel.IsExistingMatchingCard(card.sfilter,tp,LOCATION_EXTRA,0,1,nil,tpe) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function card.sop(e,tp,eg,ep,ev,re,r,rp)
	local tpe=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,card.sfilter,tp,LOCATION_EXTRA,0,1,1,nil,tpe)
	if g:GetCount()>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
end
function card.indfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER)
end
function card.prottg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and card.indfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(card.indfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():GetFlagEffect(210424256)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,card.indfilter,tp,LOCATION_MZONE,0,1,1,nil)
	e:GetHandler():RegisterFlagEffect(210424256,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function card.protop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetValue(card.efilter)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end
end
function card.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end