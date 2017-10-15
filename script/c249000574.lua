--Auium Fusion Summoner
function c249000574.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(62742651,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c249000574.ntcon)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c249000574.cost)
	e2:SetTarget(c249000574.target)
	e2:SetOperation(c249000574.operation)
	c:RegisterEffect(e2)
end
function c249000574.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil)
end
function c249000574.costfilter(c)
	return c:IsSetCard(0x1D1) and c:IsAbleToDeckAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000574.costfilter2(c,e)
	return c:IsSetCard(0x1046) and c:IsType(TYPE_MONSTER) and not c:IsPublic() and c~=e:GetHandler()
end
function c249000574.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000574.costfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000574.costfilter2,tp,LOCATION_HAND,0,1,nil,e)) end
	local option
	if Duel.IsExistingMatchingCard(c249000574.costfilter2,tp,LOCATION_HAND,0,1,nil,e)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000574.costfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000574.costfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000574.costfilter2,tp,LOCATION_HAND,0,1,nil,e) then
		option=Duel.SelectOption(tp,526,1301)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000574.costfilter2,tp,LOCATION_HAND,0,1,1,nil,e)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c249000574.costfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		Duel.SendtoDeck(g,nil,2,REASON_COST)
	end
end
function c249000574.tfilter(c,race,e,tp,lv)
	return c:IsType(TYPE_FUSION) and c:IsRace(race) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
	and (c:GetLevel()==lv-1 or c:GetLevel()==lv or c:GetLevel()==lv+1)
end
function c249000574.filter(c,e,tp)
	return c:IsFaceup() and c:GetLevel() >= 0 and c~=e:GetHandler()
		and Duel.IsExistingMatchingCard(c249000574.tfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetRace(),e,tp,c:GetLevel())
end
function c249000574.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c249000574.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c249000574.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c249000574.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000574.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local race=tc:GetRace()
	local lv=tc:GetLevel()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c249000574.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,race,e,tp,lv)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
		e1:SetRange(LOCATION_MZONE)
		e1:SetOperation(c249000574.shuffleop)
		e1:SetLabel(0)
		sg:GetFirst():RegisterEffect(e1)
		sg:GetFirst():CompleteProcedure()
	end
end
function c249000574.shuffleop(e,tp,eg,ep,ev,re,r,rp)
	if tp~=Duel.GetTurnPlayer() then return end
	local c=e:GetHandler()
	local ct=e:GetLabel()
	ct=ct+1
	e:SetLabel(ct)
	if ct==2 then
		if Duel.SendtoDeck(c,nil,2,REASON_EFFECT) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end