--created abd scripted by rising phoenix
function c100000713.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x115),7,1)
		aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x115),8,1)
			aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x115),10,1)
	c:EnableReviveLimit()
		--counter
	local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(100000713,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetCategory(CATEGORY_COUNTER)
			e1:SetCost(c100000713.costs)
		e1:SetOperation(c100000713.operation)
	c:RegisterEffect(e1)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetValue(c100000713.atkval)
	c:RegisterEffect(e6)
		--defup
	local e9=e6:Clone()
	e9:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e9)
	--search
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(100000713,0))
	e11:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e11:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_TO_GRAVE)
	e11:SetCost(c100000713.discost)
	e11:SetTarget(c100000713.tg)
	e11:SetOperation(c100000713.op)
	c:RegisterEffect(e11)
end
function c100000713.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x51,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x51,3,REASON_COST)
end
function c100000713.filter(c)
	return  c:IsSetCard(0x115) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c100000713.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000713.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c100000713.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100000713.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100000713.costs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100000713.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x51)*50
end
function c100000713.filterp(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x51,1)
end
function c100000713.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100000713.filterop,tp,LOCATION_ONFIELD,0,nil)
	local tc=g:GetFirst()
	while tc do 
		tc:AddCounter(0x51,1)
		tc=g:GetNext()
	end
end