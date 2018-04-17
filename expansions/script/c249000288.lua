--Summoning-Rite of Fusion
function c249000288.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c249000288.condition)
	e1:SetCost(c249000288.cost)
	e1:SetTarget(c249000288.target)
	e1:SetOperation(c249000288.activate)
	c:RegisterEffect(e1)
end
function c249000288.confilter(c)
	return c:IsSetCard(0x1B0) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000288.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c249000288.confilter,tp,LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>1	and not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0x9F)
	and not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0xC6)
end
function c249000288.cfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToRemoveAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000288.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000288.cfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000288.cfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000288.tfilter(c,e,tp,count)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
	and c:GetLevel() <= count*4
end
function c249000288.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local count=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and count>0
	and Duel.IsExistingTarget(c249000288.tfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,count) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000288.activate(e,tp,eg,ep,ev,re,r,rp)
	local count=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local sg=Duel.SelectMatchingCard(tp,c249000288.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,count)
	local c=e:GetHandler()
	if sg:GetCount()>0 then
		if Duel.SpecialSummon(sg,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e1:SetCountLimit(1)
			e1:SetReset(RESET_EVENT+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,3)
			e1:SetRange(LOCATION_MZONE)
			e1:SetOperation(c249000288.shuffleop)
			e1:SetLabel(0)
			sg:GetFirst():RegisterEffect(e1)
			sg:GetFirst():CompleteProcedure()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e1:SetReset(RESET_SELF_TURN+RESET_PHASE+PHASE_END,2)
			e1:SetTargetRange(1,0)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function c249000288.shuffleop(e,tp,eg,ep,ev,re,r,rp)
	if tp~=Duel.GetTurnPlayer() then return end
	local c=e:GetHandler()
	local ct=e:GetLabel()
	ct=ct+1
	e:SetLabel(ct)
	if ct==2 then
		if Duel.SendtoDeck(c,nil,2,REASON_EFFECT) then
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end