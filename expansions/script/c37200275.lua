--Doppiombra Lucertola Monarca
--Script by XGlitchy30
function c37200275.initial_effect(c)
	--unaffected
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37200275,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCondition(c37200275.immunecon)
	e1:SetTarget(c37200275.immunetg)
	e1:SetOperation(c37200275.immune)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c37200275.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--race change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37200275,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c37200275.rccost)
	e3:SetOperation(c37200275.rcop)
	c:RegisterEffect(e3)
	--aqua-type effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(37200275,4))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,37200275)
	e4:SetCondition(c37200275.effectcon)
	e4:SetTarget(c37200275.effecttg)
	e4:SetOperation(c37200275.effectop)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c37200275.reptg)
	e5:SetValue(c37200275.repval)
	e5:SetOperation(c37200275.repop)
	c:RegisterEffect(e5)
end
--filters
function c37200275.tgtg(e,c)
	return c:IsSetCard(0x2359) and c:GetRace()==e:GetHandler():GetRace()
end
function c37200275.rcfilter(c,e)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic() and c:GetRace()~=e:GetHandler():GetRace()
end
function c37200275.effectfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_AQUA)
end
function c37200275.ercfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_AQUA)
end
function c37200275.spsumfilter(c,ct,e,tp)
	return c:GetLevel()==ct and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c37200275.pctfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_AQUA)
		and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
--unaffected
function c37200275.immunecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c37200275.immunetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
end
function c37200275.immune(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,0)<=0 then return end
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c37200275.etarget)
		e1:SetValue(c37200275.efilter)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c37200275.etarget(e,c)
	return c:IsFaceup() and c:IsRace(RACE_AQUA)
end
function c37200275.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--race change
function c37200275.rccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37200275.rcfilter,tp,LOCATION_HAND,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c37200275.rcfilter,tp,LOCATION_HAND,0,1,1,nil,e)
	e:SetLabel(g:GetFirst():GetRace())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c37200275.rcop(e,tp,eg,ep,ev,re,r,rp)
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
--aqua-type effect
function c37200275.effectcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>1
		and not Duel.IsExistingMatchingCard(c37200275.effectfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c37200275.effecttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c37200275.ercfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	e:SetLabel(ct)
	if chk==0 then return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c37200275.spsumfilter,tp,LOCATION_GRAVE,0,1,nil,e:GetLabel(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c37200275.effectop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c37200275.spsumfilter),tp,LOCATION_GRAVE,0,1,1,nil,e:GetLabel(),e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--destroy replace
function c37200275.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c37200275.pctfilter,1,c,tp)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c37200275.repval(e,c)
	return c37200275.pctfilter(c,e:GetHandlerPlayer())
end
function c37200275.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
	Duel.BreakEffect()
	local ct=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x2359)
	if ct>0 then
		Duel.Damage(1-tp,ct*100,REASON_EFFECT)
	end
end