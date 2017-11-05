--coded by Lyris
--Custom Ruleset
function c2401.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(0xf7)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(c2401.start)
	c:RegisterEffect(e1)
end
c2401[0]=0
function c2401.start(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c2401[0]==0 then
		--Each player can only negate 1 effect per turn.
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_NEGATED)
		e1:SetOperation(c2401.neglimit)
		Duel.RegisterEffect(e1,0)
		local e2=e1:Clone()
		e2:SetCode(EVENT_CHAIN_DISABLED)
		Duel.RegisterEffect(e2,0)
		--Each player can only activate 1 Quick Effect, Quick-Play Spell, or Trap per opponent's turn.
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAINING)
		e3:SetOperation(c2401.actreg)
		Duel.RegisterEffect(e3,0)
		local e4=Effect.GlobalEffect()
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetCode(EFFECT_CANNOT_ACTIVATE)
		e4:SetTargetRange(1,0)
		e4:SetCondition(function(e) return e:GetHandlerPlayer()~=Duel.GetTurnPlayer() and Duel.GetFlagEffect(e:GetHandlerPlayer(),2401)~=0 end)
		e4:SetValue(c2401.aclimit)
		Duel.RegisterEffect(e4,0)
		local e5=e4:Clone()
		Duel.RegisterEffect(e5,1)
		--Each player can only control 1 card that has an effect that makes it unaffected by effects.
		local g1=Duel.GetMatchingGroup(Card.IsHasEffect,tp,0xff,0xff,nil,EFFECT_IMMUNE_EFFECT)
		for tc in aux.Next(g1) do
			tc:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsHasEffect,EFFECT_IMMUNE_EFFECT))
			tc:SetUniqueOnField(0,1,aux.FilterBoolFunction(Card.IsHasEffect,EFFECT_IMMUNE_EFFECT))
		end
		--Both players can Set cards into the Spell & Trap Zones by sending 1 Spell/Trap they control to the GY unless all of their Spell & Trap Zones are occupied.
		local e5=Effect.GlobalEffect()
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_SSET_COST)
		e5:SetTargetRange(0xff,0xff)
		e5:SetCost(aux.TRUE)
		e5:SetOperation(c2401.scostop)
		Duel.RegisterEffect(e5,tp)
		--Both players can activate Pendulum Monsters from their hand by adding 1 card from their Pendulum Zone to the Extra Deck face-up unless both of their Pendulum Zones are occupied.
		local e6=Effect.GlobalEffect()
		e6:SetType(EFFECT_TYPE_FIELD)
		e6:SetCode(EFFECT_ACTIVATE_COST)
		e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e6:SetTargetRange(1,1)
		e6:SetTarget(function(e,te,tp) return te:GetHandler():IsType(TYPE_PENDULUM) and te:IsHasType(EFFECT_TYPE_ACTIVATE) end)
		e6:SetCost(aux.TRUE)
		e6:SetOperation(c2401.acostop)
		Duel.RegisterEffect(e6,tp)
		c2401[0]=1
	end
	Duel.DisableShuffleCheck()
	Duel.ConfirmCards(0,c)
	if Duel.SendtoDeck(c,nil,-2,REASON_EFFECT)==0 then
		Duel.Exile(c,REASON_EFFECT)
	end
	if c:GetPreviousLocation()==LOCATION_HAND then
		Duel.Draw(tp,1,REASON_RULE)
	end
end
function c2401.neglimit(e,tp,eg,ep,ev,re,r,rp)
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	if not de then return end
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISABLE)
	e3:SetTargetRange(0,0xff)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,dp)
	local e4=Effect.GlobalEffect()
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetValue(c2401.effectfilter)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,dp)
	local e5=Effect.GlobalEffect()
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetValue(c2401.effectfilter)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,dp)
end
function c2401.actreg(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	if rp~=p and re:IsHasType(EFFECT_TYPE_QUICK_F+EFFECT_TYPE_QUICK_O) or (re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)) or re:GetActiveType()==TYPE_SPELL+TYPE_QUICKPLAY then
		Duel.RegisterFlagEffect(rp,2401,RESET_PHASE+PHASE_END,0,1)
	end
end
function c2401.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_QUICK_F+EFFECT_TYPE_QUICK_O) or (re:GetHandler():IsType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)) or re:GetActiveType()==TYPE_SPELL+TYPE_QUICKPLAY
end
function c2401.effectfilter(e,ct)
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return tp~=e:GetHandlerPlayer()
end
function c2401.sfilter(c)
	return c:GetSequence()<5 and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c2401.scostop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c2401.sfilter,tp,LOCATION_ONFIELD,0,1,eg) or not Duel.SelectYesNo(tp,aux.Stringid(2401,0)) then return end
	local g=Duel.SelectMatchingCard(tp,c2401.sfilter,tp,LOCATION_ONFIELD,0,1,1,eg)
	Duel.SendtoGrave(g,REASON_RULE)
end
function c2401.acostop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_PZONE,0,1,eg) and Duel.SelectYesNo(tp,aux.Stringid(2401,0))) then return end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_PZONE,0,1,1,eg)
	Duel.SendtoExtraP(g,nil,REASON_RULE)
end
