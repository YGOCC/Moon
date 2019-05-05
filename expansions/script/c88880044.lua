--CREATION-Eyes Negation Barrior
function c88880044.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--(1) When a card or effect is activated while you control a "CREATION-Eyes" Xyz monster: you can discard 1 card from your hand: Negate the activation and banish that card.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c88880044.discon)
	e1:SetTarget(c88880044.distg)
	e1:SetOperation(c88880044.disop)
	c:RegisterEffect(e1)
	--(2) When an opponents monster declares an attack, while you control a "CREATION-Eyes" Xyz monster: you can discard 1 card; Negate the attack and banish that monster. If a monster is banished by this effect: Increase the ATK of all "CREATION-Eyes" Xyz monsters you control by half the banished monsters ATK.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c88880044.discon2)
	e2:SetOperation(c88880044.disop2)
	c:RegisterEffect(e2)
	--(3) If a monster is banished by this effect: Increase the ATK of all "CREATION-Eyes" Xyz monsters you control by half the banished monsters ATK.
end
--(1)
function c88880044.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1889)
end
function c88880044.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and (re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)) and Duel.IsExistingMatchingCard(c88880044.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsChainNegatable(ev)
end
function c88880044.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c88880044.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g1=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_DECK,0,nil)
	local select=2
	Duel.Hint(HINT_SELECTMSG,tp,0)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		select=Duel.SelectOption(tp,aux.Stringid(88880044,0),aux.Stringid(88880044,1))
	elseif g1:GetCount()>0 then
		select=Duel.SelectOption(tp,aux.Stringid(88880044,0))
	elseif g2:GetCount()>0 then
		select=Duel.SelectOption(tp,aux.Stringid(88880044,1))+1
	end
	if select==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=g1:Select(tp,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	elseif select==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		Duel.DiscardDeck(tp,1,REASON_EFFECT)
	end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
--(2)
function c88880044.discon2(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c88880044.disop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g1=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_DECK,0,nil)
	local select=2
	Duel.Hint(HINT_SELECTMSG,tp,0)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		select=Duel.SelectOption(tp,aux.Stringid(88880044,0),aux.Stringid(88880044,1))
	elseif g1:GetCount()>0 then
		select=Duel.SelectOption(tp,aux.Stringid(88880044,0))
	elseif g2:GetCount()>0 then
		select=Duel.SelectOption(tp,aux.Stringid(88880044,1))+1
	end
	if select==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=g1:Select(tp,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	elseif select==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		Duel.DiscardDeck(tp,1,REASON_EFFECT)
	end
	local tc=Duel.GetAttacker()
	Duel.NegateAttack()
	Duel.BreakEffect()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end