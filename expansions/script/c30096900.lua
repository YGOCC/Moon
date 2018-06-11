--Sylphic Fantasies
--Scripted by Specific
function c30096900.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--ATK/DEF Decrease
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.NOT(aux.TargetBoolFunction(Card.IsType,TYPE_SPIRIT)))
	e2:SetValue(c30096900.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--Return to Hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(30096900,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,30096900)
	e4:SetCondition(c30096900.thcon)
	e4:SetTarget(c30096900.thtg)
	e4:SetOperation(c30096900.thop)
	c:RegisterEffect(e4)
end
function c30096900.vfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x125)
end
function c30096900.atkval(e,c)
	return Duel.GetMatchingGroupCount(c30096900.vfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*-100
end
function c30096900.cfilter(c,tp)
	return c:IsSetCard(0x125) and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c30096900.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c30096900.cfilter,1,nil,tp)
end
function c30096900.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c30096900.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end