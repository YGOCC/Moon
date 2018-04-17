--Summoning-Rite of Xyz
function c249000289.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c249000289.condition)
	e1:SetCost(c249000289.cost)
	e1:SetTarget(c249000289.target)
	e1:SetOperation(c249000289.activate)
	c:RegisterEffect(e1)
end
function c249000289.confilter(c)
	return c:IsSetCard(0x1B0) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000289.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c249000289.confilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>1	and not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0x9F)
	and not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0xC6)
end
function c249000289.cfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToRemoveAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000289.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000289.cfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000289.cfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000289.tfilter(c,e,tp,count)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
	and c:GetRank() <= count*3
end
function c249000289.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local count=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and count>0
	and Duel.IsExistingTarget(c249000289.tfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,count) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000289.activate(e,tp,eg,ep,ev,re,r,rp)
	local count=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local sg=Duel.SelectMatchingCard(tp,c249000289.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,count)
	local c=e:GetHandler()
	if sg:GetCount()>0 then
		if Duel.SpecialSummon(sg,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) then
			c:CancelToGrave()
			Duel.Overlay(sg:GetFirst(),Group.FromCards(c))
			local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
			if tc2 then
				Duel.Overlay(sg:GetFirst(),tc2)
			end
		end
	end
end