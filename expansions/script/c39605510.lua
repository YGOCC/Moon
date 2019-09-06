--Zextra, The Pandemonium Dragon King
function c39605510.initial_effect(c)
	aux.AddOrigPandemoniumType(c)
	aux.EnablePandemoniumAttribute(c)
	--To activate this card, you must Tribute 2 "Pandemoniumgraph" monsters or 1 "Zextral" monster.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c39605510.actchk)
	c:RegisterEffect(e3)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_CHAIN_ACTIVATING)
	e9:SetRange(LOCATION_SZONE)
	e9:SetCondition(c39605510.actcon)
	e9:SetOperation(c39605510.actcost)
	c:RegisterEffect(e9)
	--You can only Pandemonium Summon Pandemonium Monsters. This effect cannot be negated.
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e5:SetTargetRange(1,0)
	e5:SetTarget(c39605510.splimit)
	c:RegisterEffect(e5)
	--Pandemonium Summoned monsters can attack twice on monsters during the turn they're Pandemonium Summoned.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(function(e,c) return aux.PandActCheck(e) and c:IsSummonType(SUMMON_TYPE_SPECIAL+726) and c:IsStatus(STATUS_SPSUMMON_TURN) end)
	e1:SetValue(2)
	c:RegisterEffect(e1)
	--Cannot be Normal Summoned/Set, or Pendulum Summoned from the hand.
	c:EnableReviveLimit()
	--Must be Special Summoned by the effect of "Zextral Armageddon Sorcerer" or Pandemonium Summoned while "Zextral Armageddon Sorcerer" is in the Pandemonium Zone.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c39605510.spcon)
	c:RegisterEffect(e2)
	--If this card is Summoned: All other face-up monsters' ATK and DEF on the field become 0.
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetOperation(c39605510.atkop)
	c:RegisterEffect(e6)
	local e0=e6:Clone()
	e0:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e0)
	--When a Spell/Trap Card or another monster's effect is activated (Quick Effect): You can shuffle 1 face-up Pandemonium Monster from your Extra Deck into the Deck, negate the activation, and if you do, destroy that card.
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e7:SetCondition(c39605510.negcon)
	e7:SetCost(c39605510.negcost)
	e7:SetTarget(c39605510.negtg)
	e7:SetOperation(c39605510.negop)
	c:RegisterEffect(e7)
	--This card's maximum number of attacks on monsters during the Battle Phase is equal to the number of face-up Pandemonium Monsters in your Extra Deck with different names.
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e8:SetValue(c39605510.atkval)
	c:RegisterEffect(e8)
end
function c39605510.acfilter(c,g)
	return c:IsFaceup() and (c:IsSetCard(0xf79) or (c:IsSetCard(0xcf80)  and g:IsExists(Card.IsSetCard,1,c,0xcf80)))
end
function c39605510.actchk(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetReleaseGroup(tp)
	return e:GetHandler():IsFacedown() and not g:IsExists(c39605510.acfilter,1,nil,g)
end
function c39605510.actcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler()
end
function c39605510.actcost(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetReleaseGroup(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:FilterSelect(tp,c39605510.acfilter,1,1,nil,g)
	Duel.Release(rg,REASON_COST)
end
function c39605510.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsType(TYPE_PANDEMONIUM) then return false end
	return aux.PandActCheck(e) and bit.band(sumtype,SUMMON_TYPE_SPECIAL+726)==SUMMON_TYPE_SPECIAL+726
end
function c39605510.spcon(e,se,sp,st)
	return (Duel.IsExistingMatchingCard(function(c) return c:IsCode(39615023) and c:IsFaceup() end,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
		and bit.band(st,SUMMON_TYPE_SPECIAL+726)==SUMMON_TYPE_SPECIAL+726) or (se and se:GetHandler():IsCode(39615023))
end
function c39605510.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c39605510.negcon(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or (re:IsActiveType(TYPE_MONSTER) and re:GetHandler()~=e:GetHandler()))
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c39605510.filter(c)
	return c:IsType(TYPE_PANDEMONIUM) and c:IsFaceup()
end
function c39605510.cfilter(c)
	return c39605510.filter(c) and c:IsAbleToDeckAsCost()
end
function c39605510.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c39605510.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c39605510.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c39605510.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c39605510.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c39605510.atkval(e)
	return Duel.GetMatchingGroup(c39605510.filter,e:GetHandlerPlayer(),LOCATION_EXTRA,0,nil):GetClassCount(Card.GetCode)-1
end
