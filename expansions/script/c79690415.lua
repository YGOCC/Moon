--Shrine on the Edge of Termina
--Scripted by ISP
function c79690415.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79690415+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c79690415.activate)
	c:RegisterEffect(e1)
	--ATK/DEF Increase (Sylphic)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x125))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--ATK/DEF Increase (Termina)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x12c))
	e4:SetValue(300)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
	--To Deck
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EFFECT_TO_HAND_REDIRECT)
	e6:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e6:SetCondition(c79690415.tdcon)
	e6:SetTarget(c79690415.tdtg)
	e6:SetValue(LOCATION_DECKSHF)
	c:RegisterEffect(e6)
end
function c79690415.thfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x125) or c:IsSetCard(0x12c)) and c:IsAbleToHand()
end
function c79690415.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c79690415.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(79690415,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c79690415.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x125) or c:IsSetCard(0x12c)) and c:IsType(TYPE_CONTINUOUS)
end
function c79690415.tdcon(e)
	local g=Duel.GetMatchingGroup(c79690415.cfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,nil)
	return g:GetClassCount(Card.GetCode)>=3
end
function c79690415.tdtg(e,c)
	return (c:IsFacedown() or not (c:IsSetCard(0x125) or c:IsSetCard(0x12c))) and c:IsReason(REASON_EFFECT)
end