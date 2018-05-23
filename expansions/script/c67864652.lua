--Mekbuster Frame LS3-I6
--Keddy was here~
function c67864652.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,67864641,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),1,true,true)
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67864652,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c67864652.mvcon)
	e1:SetTarget(c67864652.mvtg)
	e1:SetOperation(c67864652.mvop)
	c:RegisterEffect(e1)
	--Salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67864652,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,67864652)
	e2:SetTarget(c67864652.thtg)
	e2:SetOperation(c67864652.thop)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67864650,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c67864652.spcon)
	e3:SetTarget(c67864652.sptg)
	e3:SetOperation(c67864652.spop)
	c:RegisterEffect(e3)
end
function c67864652.mvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and Duel.GetFlagEffect(tp,67864652)==0
end
function c67864652.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAttackPos()
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c67864652.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsAttackPos() and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			nseq=math.log(s,2)
			Duel.MoveSequence(c,nseq)
			Duel.RegisterFlagEffect(tp,67864652,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c67864652.thfilter(c)
	return c:IsType(TYPE_SPELL) and (c:IsSetCard(0x2a6) or c:IsSetCard(0x3a6))
end
function c67864652.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=2
		and Duel.IsExistingTarget(c67864652.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c67864652.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,tp,LOCATION_GRAVE)
end
function c67864652.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if not c:IsRelateToEffect(e) or Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=1 then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(Card.IsDiscardable,nil)
	if #g<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=g:Select(tp,2,2,nil)
	if #sg<=0 then return end
	if Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)>0 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c67864652.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and not c:IsFacedown()
end
function c67864652.spfilter(c,e,tp,slv)
	local lv=c:GetLevel()
	return (c:IsSetCard(0x2a6) or c:IsRace(RACE_MACHINE)) and lv>0 and (not slv or lv==slv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67864652.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return false end
		if ft==1 or Duel.IsPlayerAffectedByEffect(tp,59822133) then
			return Duel.IsExistingMatchingCard(c67864652.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,8)
		else
			local g=Duel.GetMatchingGroup(c67864652.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
			return g:CheckWithSumEqual(Card.GetLevel,8,1,ft)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c67864652.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft==1 or Duel.IsPlayerAffectedByEffect(tp,59822133) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c67864652.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,8)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		local g=Duel.GetMatchingGroup(c67864652.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
		if g:CheckWithSumEqual(Card.GetLevel,8,1,ft) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:SelectWithSumEqual(tp,Card.GetLevel,8,1,ft)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
