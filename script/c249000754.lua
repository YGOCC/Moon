--Secret-Rites Summoner
function c249000754.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c249000754.spcon1)
	e1:SetOperation(c249000754.spop1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,249000754)
	e2:SetCondition(c249000754.condition)
	e2:SetCost(c249000754.cost)
	e2:SetTarget(c249000754.target)
	e2:SetOperation(c249000754.operation)
	c:RegisterEffect(e2)
end
function c249000754.spfilter1(c,att)
	return c:IsSetCard(0x1EF) and c:IsAbleToDeckOrExtraAsCost()
end
function c249000754.spfilter2(c,att)
	return c:IsType(TYPE_XYZ) and c:IsAbleToDeckOrExtraAsCost()
end
function c249000754.spcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000754.spfilter1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c249000754.spfilter2,tp,LOCATION_GRAVE,0,1,nil)
end
function c249000754.spop1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c249000754.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,c249000754.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
end
function c249000754.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil)-Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)>=2
end
function c249000754.confilter(c)
	return c:IsSetCard(0x1EF) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000754.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c249000754.confilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>1
end
function c249000754.costfilter(c,e,tp)
	return c:IsLevelAbove(1) and c:GetOriginalLevel()<=8 and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c249000754.costfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetOriginalLevel(),c:GetOriginalAttribute())
end
function c249000754.costfilter2(c,e,tp,lv,att)
	return c:IsAttribute(att) and c:GetRank()==lv and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c249000754.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000754.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,c249000754.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c249000754.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c249000754.tgfilter(c,e,tp,lv,att)
	return c:IsAttribute(att) and c:GetRank()==lv and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c249000754.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local g=Duel.SelectMatchingCard(tp,c249000754.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetOriginalLevel(),tc:GetOriginalAttribute())
	local sc=g:GetFirst()
	if not sc then return end
	if Duel.SendtoGrave(sc,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_GRAVE) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)
	and Duel.SelectYesNo(tp,2) then
		Duel.SendtoGrave(Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil),REASON_EFFECT)
		if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP)~=0 then
			local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
			if tc2 then
				Duel.Overlay(sc,tc2)
			end
			tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
			if tc2 then
				Duel.Overlay(sc,tc2)
			end
		end
	end
end