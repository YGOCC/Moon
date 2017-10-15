--Materialization Magic Synchro Force
function c249000732.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c249000732.cost)
	e1:SetTarget(c249000732.target)
	e1:SetOperation(c249000732.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(249000732,ACTIVITY_SPSUMMON,c249000732.counterfilter)
end
function c249000732.counterfilter(c)
	return c:GetSummonType()~=SUMMON_TYPE_LINK
end
function c249000732.costfilter(c)
	return c:IsSetCard(0x1EC) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c249000732.costfilter2(c)
	return c:IsSetCard(0x1EC) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c249000732.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	if chk==0 then return Duel.GetCustomActivityCount(249000732,tp,ACTIVITY_SPSUMMON)==0 and (Duel.IsExistingMatchingCard(c249000732.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000732.costfilter2,tp,LOCATION_HAND,0,1,c)) end
	local option
	if Duel.IsExistingMatchingCard(c249000732.costfilter2,tp,LOCATION_HAND,0,1,c)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000732.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000732.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000732.costfilter2,tp,LOCATION_HAND,0,1,c) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000732.costfilter2,tp,LOCATION_HAND,0,1,1,c)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000732.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c249000732.splimitcost)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c249000732.splimitcost(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c249000732.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and not c:IsType(TYPE_SYNCHRO)
end
function c249000732.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsLevelAbove(1) end
	if chk==0 then return Duel.IsExistingTarget(c249000732.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c249000732.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000732.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local lv=tc:GetLevel()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ac=Duel.AnnounceCardFilter(tp,tc:GetOriginalRace(),OPCODE_ISRACE,tc:GetOriginalAttribute(),OPCODE_ISATTRIBUTE,OPCODE_AND,TYPE_SYNCHRO,OPCODE_ISTYPE,OPCODE_AND,c:GetOriginalCode(),OPCODE_ISCODE,OPCODE_OR)
	if ac and ac~=c:GetOriginalCode() then
		local sc=Duel.CreateToken(tp,ac)
		Duel.SendtoDeck(sc,nil,2,REASON_RULE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		e1:SetLabel(ac)
		e1:SetTarget(c249000732.splimit)
		Duel.RegisterEffect(e1,tp)
		if (lv-1==sc:GetLevel() or lv==sc:GetLevel() or lv+1==sc:GetLevel()) and Duel.GetLocationCountFromEx(tp)>0 and sc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
			and Duel.SelectYesNo(tp,2) then
			sc:SetMaterial(Group.FromCards(tc))
			Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end
function c249000732.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return (not se:GetHandler():IsSetCard(0x1EC)) and c:IsCode(e:GetLabel())
end