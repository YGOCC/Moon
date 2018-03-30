--Doppiombra Cacciatore di Teschi
--Script by XGlitchy30
function c37200274.initial_effect(c)
	--unaffected
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37200274,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c37200274.immunecost)
	e1:SetOperation(c37200274.immune)
	c:RegisterEffect(e1)
	--stats
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c37200274.statscon)
	e2:SetValue(-600)
	c:RegisterEffect(e2)
	local e2x=e2:Clone()
	e2x:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2x)
	--race change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37200274,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c37200274.rccost)
	e3:SetOperation(c37200274.rcop)
	c:RegisterEffect(e3)
	--insect-type effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(37200274,4))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,37200274)
	e4:SetCondition(c37200274.effectcon)
	e4:SetTarget(c37200274.effecttg)
	e4:SetOperation(c37200274.effectop)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c37200274.reptg)
	e5:SetValue(c37200274.repval)
	e5:SetOperation(c37200274.repop)
	c:RegisterEffect(e5)
end
--filters
function c37200274.rcfilter(c,e)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic() and c:GetRace()~=e:GetHandler():GetRace()
end
function c37200274.effectfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_INSECT)
end
function c37200274.ercfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c37200274.pctfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_INSECT)
		and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c37200274.spfilter(c,e,tp)
	return c:IsRace(RACE_INSECT) and not c:IsCode(37200274) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
--unaffected
function c37200274.immunecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c37200274.immune(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c37200274.etarget)
	e1:SetValue(c37200274.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c37200274.etarget(e,c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c37200274.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--stats
function c37200274.statscon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
--race change
function c37200274.rccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37200274.rcfilter,tp,LOCATION_HAND,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c37200274.rcfilter,tp,LOCATION_HAND,0,1,1,nil,e)
	e:SetLabel(g:GetFirst():GetRace())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c37200274.rcop(e,tp,eg,ep,ev,re,r,rp)
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
--insect-type effect
function c37200274.effectcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>1
		and not Duel.IsExistingMatchingCard(c37200274.effectfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c37200274.effecttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetMatchingGroupCount(c37200274.ercfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	e:SetLabel(ct)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,ct,0,0)
end
function c37200274.effectop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
--destroy replace
function c37200274.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c37200274.pctfilter,1,c,tp)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c37200274.repval(e,c)
	return c37200274.pctfilter(c,e:GetHandlerPlayer())
end
function c37200274.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(c37200274.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then
		if Duel.SelectYesNo(tp,aux.Stringid(37200274,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c37200274.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				if Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+0x1fe0000)
					g:GetFirst():RegisterEffect(e1,true)
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetReset(RESET_EVENT+0x1fe0000)
					g:GetFirst():RegisterEffect(e2,true)
					local e3=Effect.CreateEffect(e:GetHandler())
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_CANNOT_ATTACK)
					e3:SetReset(RESET_EVENT+0x1fe0000)
					g:GetFirst():RegisterEffect(e3,true)
					Duel.SpecialSummonComplete()
				end
			end
		end
	end
end