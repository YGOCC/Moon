--Doppiombra Illusionista
--Script by XGlitchy30
function c37200271.initial_effect(c)
	--unaffected
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37200271,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c37200271.immunecost)
	e1:SetOperation(c37200271.immune)
	c:RegisterEffect(e1)
	--avoid battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c37200271.avdamage)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--race change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37200271,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c37200271.rccost)
	e3:SetOperation(c37200271.rcop)
	c:RegisterEffect(e3)
	--spellcaster-type effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(37200271,4))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,37200271)
	e4:SetCondition(c37200271.effectcon)
	e4:SetTarget(c37200271.effecttg)
	e4:SetOperation(c37200271.effectop)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c37200271.reptg)
	e5:SetValue(c37200271.repval)
	e5:SetOperation(c37200271.repop)
	c:RegisterEffect(e5)
end
--filters
function c37200271.avdamage(e,c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c37200271.rcfilter(c,e)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic() and c:GetRace()~=e:GetHandler():GetRace()
end
function c37200271.effectfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_SPELLCASTER)
end
function c37200271.ercfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c37200271.setfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c37200271.fdsetfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSSetable() and not c:IsType(TYPE_FIELD)
end
function c37200271.pctfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_SPELLCASTER)
		and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c37200271.scfilter(c)
	return c:IsSetCard(0x2359) and c:IsAbleToHand() and not c:IsCode(37200271)
end
--unaffected
function c37200271.immunecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() and c:IsFaceup() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c37200271.immune(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c37200271.etarget)
	e1:SetValue(c37200271.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c37200271.etarget(e,c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c37200271.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--race change
function c37200271.rccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37200271.rcfilter,tp,LOCATION_HAND,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c37200271.rcfilter,tp,LOCATION_HAND,0,1,1,nil,e)
	e:SetLabel(g:GetFirst():GetRace())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c37200271.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(e:GetLabel())
		c:RegisterEffect(e1)
	end
end
--spellcaster-type effect
function c37200271.effectcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>1
		and not Duel.IsExistingMatchingCard(c37200271.effectfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c37200271.effecttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c37200271.ercfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	e:SetLabel(ct)
	if chk==0 then return ct>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=e:GetLabel() end
end
function c37200271.effectop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,ct)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if Duel.GetLocationCount(tp,LOCATION_FZONE)<=0 then
		local g=Duel.GetDecktopGroup(tp,ct):Filter(c37200271.fdsetfilter,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g:Select(tp,1,1,nil)
			Duel.SSet(tp,sg:GetFirst())
			Duel.ConfirmCards(1-tp,sg:GetFirst())
		end
		Duel.ShuffleDeck(tp)
	else
		local g=Duel.GetDecktopGroup(tp,ct):Filter(c37200271.setfilter,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g:Select(tp,1,1,nil)
			Duel.SSet(tp,sg:GetFirst())
			Duel.ConfirmCards(1-tp,sg:GetFirst())
		end
		Duel.ShuffleDeck(tp)
	end
end
--destroy replace
function c37200271.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c37200271.pctfilter,1,c,tp)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c37200271.repval(e,c)
	return c37200271.pctfilter(c,e:GetHandlerPlayer())
end
function c37200271.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(c37200271.scfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
		if Duel.SelectYesNo(tp,aux.Stringid(37200270,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c37200271.scfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end