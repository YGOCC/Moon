--Doppiombra Visionario
--Script by XGlitchy30
function c37200272.initial_effect(c)
	--unaffected
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37200272,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c37200272.immunecost)
	e1:SetOperation(c37200272.immune)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c37200272.negtg)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--race change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37200272,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c37200272.rccost)
	e3:SetOperation(c37200272.rcop)
	c:RegisterEffect(e3)
	--psychic-type effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(37200273,4))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,37200272)
	e4:SetCondition(c37200272.effectcon)
	e4:SetTarget(c37200272.effecttg)
	e4:SetOperation(c37200272.effectop)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c37200272.reptg)
	e5:SetValue(c37200272.repval)
	e5:SetOperation(c37200272.repop)
	c:RegisterEffect(e5)
end
--filters
function c37200272.rcfilter(c,e)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic() and c:GetRace()~=e:GetHandler():GetRace()
end
function c37200272.effectfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_PSYCHO)
end
function c37200272.ercfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHO)
end
function c37200272.pctfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_PSYCHO) 
		and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c37200272.rmfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAbleToRemove()
end
--unaffected
function c37200272.immunecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and c:IsFaceup() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c37200272.immune(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c37200272.etarget)
	e1:SetValue(c37200272.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c37200272.etarget(e,c)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHIC)
end
function c37200272.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c37200272.notpublic(c)
	return not c:IsPublic()
end
--negate
function c37200272.negtg(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and e:GetHandler():GetColumnGroup():IsContains(c)
end
--race change
function c37200272.rccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37200272.rcfilter,tp,LOCATION_HAND,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c37200272.rcfilter,tp,LOCATION_HAND,0,1,1,nil,e)
	e:SetLabel(g:GetFirst():GetRace())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c37200272.rcop(e,tp,eg,ep,ev,re,r,rp)
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
--psychic-type effect
function c37200272.effectcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>1
		and not Duel.IsExistingMatchingCard(c37200272.effectfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c37200272.effecttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c37200272.ercfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	e:SetLabel(ct)
	if chk==0 then return ct>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=e:GetLabel() end
end
function c37200272.effectop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
	local g=Duel.GetMatchingGroup(c37200272.notpublic,tp,0,LOCATION_HAND,nil)
	local cg=g:Select(1-tp,ct,ct,nil)
	Duel.ConfirmCards(tp,cg)
	Duel.ShuffleHand(1-tp)
end
--destroy replace
function c37200272.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c37200272.pctfilter,1,c,tp) and Duel.CheckLPCost(tp,800)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.PayLPCost(tp,800)
		return true
	else return false end
end
function c37200272.repval(e,c)
	return c37200272.pctfilter(c,e:GetHandlerPlayer())
end
function c37200272.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(c37200272.rmfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) then
		if Duel.SelectYesNo(tp,aux.Stringid(37200272,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,c37200272.rmfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end