--Foreboding_Amassment
function c210310306.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c210310306.target)
	e1:SetOperation(c210310306.operation)
	c:RegisterEffect(e1)
end
function c210310306.cfilter(c)
	return (c:IsAttribute(ATTRIBUTE_WATER)	or c:IsAttribute(ATTRIBUTE_WIND))
	and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end

function c210310306.filter(c)
	return c:IsSetCard(0x18) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c210310306.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_DECK) and c210310306.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c210310306.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c210310306.cfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c210310306.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
end
function c210310306.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c210310306.filter,tp,LOCATION_DECK,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCondition(c210310306.accon)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x18))
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	end
	end
function c210310306.accon(e)
	return e:GetLabel()~=Duel.GetTurnCount() and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end


