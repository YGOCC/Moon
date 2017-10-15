--Academy Ahri
function c11000551.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--add
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11000551,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,11000551)
	e2:SetCost(c11000551.cost)
	e2:SetTarget(c11000551.target)
	e2:SetOperation(c11000551.activate)
	c:RegisterEffect(e2)
end
function c11000551.cfilter(c,tp)
	return c:IsSetCard(0x1FE) and (c:IsControler(tp) or c:IsFaceup()) and c:IsType(TYPE_MONSTER)
end
function c11000551.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c11000551.cfilter,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c11000551.cfilter,1,1,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function c11000551.filter(c)
	return c:IsSetCard(0x1FE) and c:IsAbleToHand()
end
function c11000551.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11000551.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11000551.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11000551.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end