--Mysterious Force
function c53313928.initial_effect(c)
	--Target 1 monster you control, banish 1 face-up monster in your Extra Deck, GY or face-up on your side of the field, the targeted monster gains the banished monster's effect until the end phase. You can only activate 1 "Mysterious Force" per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,53313928+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetTarget(c53313928.target)
	e1:SetOperation(c53313928.activate)
	c:RegisterEffect(e1)
end
function c53313928.filter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsType(TYPE_EFFECT) and c:IsAbleToRemove()
end
function c53313928.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(function(c,tp) return Duel.IsExistingMatchingCard(c53313928.filter,tp,0x54,0,1,c) end,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c53313928.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c53313901.filter,tp,0x54,0,1,1,c)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0
		and c:IsRelateToEffect(e) and c:IsFaceup() then
		c:CopyEffect(g:GetFirst():GetCode(),RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	end
end
