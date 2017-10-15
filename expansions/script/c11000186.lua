--PROJECT: Kha'Zix
function c11000186.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1F7),4,2)
	c:EnableReviveLimit()
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11000186,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c11000186.discon)
	e3:SetCost(c11000186.discost)
	e3:SetTarget(c11000186.distg)
	e3:SetOperation(c11000186.disop)
	c:RegisterEffect(e3)
end
function c11000186.discon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c11000186.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)	
end
function c11000186.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c11000186.afilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1F7) and c:IsAbleToHand()
end
function c11000186.bfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x1F7) and c:IsAbleToHand()
end
function c11000186.cfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x1F7) and c:IsAbleToHand()
end
function c11000186.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local tc=eg:GetFirst()
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		Duel.BreakEffect()
		if tc:IsType(TYPE_MONSTER) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c11000186.afilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		end
		if tc:IsType(TYPE_SPELL) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c11000186.bfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		end
		if tc:IsType(TYPE_TRAP) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c11000186.cfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		end
	end
end
