--Doppiombra Samurai
--Script by XGlitchy30
function c37200270.initial_effect(c)
	--unaffected
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37200270,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCost(c37200270.immunecost)
	e1:SetOperation(c37200270.immune)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(37200270,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c37200270.spcon)
	e2:SetTarget(c37200270.sptg)
	e2:SetOperation(c37200270.spop)
	c:RegisterEffect(e2)
	--race change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37200270,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c37200270.rccost)
	e3:SetOperation(c37200270.rcop)
	c:RegisterEffect(e3)
	--warrior-type effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(37200270,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,37200270)
	e4:SetCondition(c37200270.effectcon)
	e4:SetTarget(c37200270.effecttg)
	e4:SetOperation(c37200270.effectop)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c37200270.reptg)
	e5:SetValue(c37200270.repval)
	e5:SetOperation(c37200270.repop)
	c:RegisterEffect(e5)
end
--filters
function c37200270.spfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and not c:IsCode(37200270)
end
function c37200270.rcfilter(c,e)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic() and c:GetRace()~=e:GetHandler():GetRace()
end
function c37200270.effectfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_WARRIOR)
end
function c37200270.ercfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function c37200270.spsumfilter(c,lv,e,tp)
	return c:GetLevel()==lv and c:IsRace(RACE_WARRIOR)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c37200270.pctfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_WARRIOR)
		and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
--unaffected
function c37200270.immunecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c37200270.immune(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c37200270.etarget)
	e1:SetValue(c37200270.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c37200270.etarget(e,c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function c37200270.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--spsummon
function c37200270.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c37200270.spfilter,1,nil)
end
function c37200270.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c37200270.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--race change
function c37200270.rccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37200270.rcfilter,tp,LOCATION_HAND,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c37200270.rcfilter,tp,LOCATION_HAND,0,1,1,nil,e)
	e:SetLabel(g:GetFirst():GetRace())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c37200270.rcop(e,tp,eg,ep,ev,re,r,rp)
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
--warrior-type effect
function c37200270.effectcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>1
		and not Duel.IsExistingMatchingCard(c37200270.effectfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c37200270.effecttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c37200270.ercfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	e:SetLabel(ct)
	if chk==0 then return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c37200270.spsumfilter,tp,LOCATION_DECK,0,1,nil,e:GetLabel(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c37200270.effectop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c37200270.spsumfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel(),e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--destroy replace
function c37200270.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c37200270.pctfilter,1,c,tp)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c37200270.repval(e,c)
	return c37200270.pctfilter(c,e:GetHandlerPlayer())
end
function c37200270.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(c37200270.ercfilter,tp,LOCATION_MZONE,0,1,nil) then
		if Duel.SelectYesNo(tp,aux.Stringid(37200270,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g=Duel.SelectMatchingCard(tp,c37200270.ercfilter,tp,LOCATION_MZONE,0,1,1,nil)
			local tc=g:GetFirst()
			if tc and tc:IsFaceup() then
				local atk=tc:GetTextAttack()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				e1:SetValue(atk)
				tc:RegisterEffect(e1)
			end
		end
	end
end