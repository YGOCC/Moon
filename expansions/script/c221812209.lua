--Viravolve Pervading Animal
function c221812209.initial_effect(c)
	c:EnableReviveLimit()
	--Matrials: 3 Level 1 Cyberse monsters
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERSE),1,3)
	--When this card is targeted for an attack or by an opponent's card effect: You can detach 1 material from this card; negate the activation or attack, and if you do, destroy it, and if you do that, Special Summon 1 "Viravolve Pervading Animal" from your Extra Deck.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,221812209)
	e2:SetCost(c221812209.descost)
	e2:SetTarget(c221812209.destg)
	e2:SetOperation(c221812209.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c221812209.descon2)
	c:RegisterEffect(e3)
end
function c221812209.descon2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c221812209.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c221812209.filter(c,e,tp)
	return c:IsCode(221812209) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c221812209.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if chk==0 then return ((Duel.GetAttackTarget()==e:GetHandler() and tg and tg:IsOnField()) or (g and g:IsContains(e:GetHandler()) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and Duel.IsChainNegatable(ev)
		and re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re)))
		and Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c221812209.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c221812209.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=nil
	if Duel.NegateAttack() then
		tc=Duel.GetAttacker()
	elseif Duel.NegateActivation(ev) and re:IsRelateToEffect(re) then
		tc=re:GetHandler()
	end
	if tc and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if Duel.GetLocationCountFromEx(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c221812209.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
