--Zextra, The Pandemonium Dragon King
function c39605510.initial_effect(c)
	aux.AddOrigPandemoniumType(c)
	aux.EnablePandemoniumAttribute(c)
	--You can only activate this card by tributing 1 "Pandemoniumgraph" or "Zextral" monster.
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
	e9:SetCondition(c39605510.negcon)
	e9:SetOperation(c39605510.actcost)
	c:RegisterEffect(e9)
	--When this card is activated: Negate the effects of all non-Pandemonium monsters your opponent controls.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c39605510.negcon)
	e4:SetOperation(c39605510.negop)
	c:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetLabelObject(e4)
	e1:SetCondition(c39605510.negcon)
	e1:SetOperation(function(e) e:GetHandler():CreateEffectRelation(e:GetLabelObject()) end)
	c:RegisterEffect(e1)
	--If you control any other card on the field: You cannot use this card for a Pandemonium Summon.
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetTarget(c39605510.splimit)
	c:RegisterEffect(e5)
	--Cannot be Normal Summoned/Set.
	c:EnableUnsummonable()
	--Cannot be Special Summoned, Except by Pandemonium Summon Using "Zextral Armageddon Sorcerer".
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c39605510.spcon)
	c:RegisterEffect(e2)
	--When this card is summoned: All face-up monsters your opponent controls ATK and DEF becomes 0.
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetOperation(c39605510.atkop)
	c:RegisterEffect(e6)
	local e0=e6:Clone()
	e0:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e0)
	--When this card attacks, Your opponent cannot activate effects.
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EFFECT_CANNOT_ACTIVATE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,1)
	e7:SetValue(c39605510.aclimit)
	e7:SetCondition(c39605510.actcon)
	c:RegisterEffect(e7)
	--This card can have number of attacks equal to the number of pandemonium monsters in your Extra Deck and Graveyard.
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_EXTRA_ATTACK)
	e8:SetValue(c39605510.atkval)
	c:RegisterEffect(e8)
end
function c39605510.acfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0xf79) or c:IsSetCard(0xcf80))
end
function c39605510.actchk(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown() and not Duel.GetReleaseGroup(tp):IsExists(c39605510.acfilter,1,nil)
end
function c39605510.actcost(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.GetReleaseGroup(tp):FilterSelect(tp,c39605510.acfilter,1,1,nil)
	Duel.Release(rg,REASON_COST)
end
function c39605510.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler()
end
function c39605510.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:GetType()&TYPE_PANDEMONIUM==0 end,tp,0,LOCATION_MZONE,nil)
	for nc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		nc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		nc:RegisterEffect(e2)
		if nc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			nc:RegisterEffect(e3)
		end
	end
end
function c39605510.splimit(e,c,sump,sumtype,sumpos,targetp)
	if Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==1 then return false end
	return bit.band(sumtype,SUMMON_TYPE_SPECIAL+726)==SUMMON_TYPE_SPECIAL+726
end
function c39605510.spcon(e,se,sp,st)
	return Duel.IsExistingMatchingCard(function(c) return c:IsCode(39615023) and c:IsFaceup() end,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
		and bit.band(st,SUMMON_TYPE_SPECIAL+726)==SUMMON_TYPE_SPECIAL+726
end
function c39605510.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
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
function c39605510.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c39605510.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c39605510.atkval(e)
	return Duel.GetMatchingGroupCount(function(c) return c:GetType()&TYPE_PANDEMONIUM==TYPE_PANDEMONIUM end,e:GetHandlerPlayer(),LOCATION_EXTRA+LOCATION_GRAVE,0,nil)-1
end
