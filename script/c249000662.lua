--Xyz-Knight-Summoner Wind
function c249000662.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c249000662.spcon)
	c:RegisterEffect(e1)
	--xyz summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,249000662)
	e2:SetCost(c249000662.cost)
	e2:SetTarget(c249000662.target)
	e2:SetOperation(c249000662.operation)
	c:RegisterEffect(e2)
end
function c249000662.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and	Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c249000662.costfilter(c)
	return c:IsSetCard(0x6073) and c:IsDiscardable() and c:IsType(TYPE_MONSTER)
end
function c249000662.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000662.costfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c249000662.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	e:SetLabel(g:GetFirst():GetOriginalAttribute())
end
function c249000662.filter1(c,e,tp)
	return c:IsSetCard(0x6073) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
		and Duel.IsExistingMatchingCard(c249000662.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c:GetOriginalAttribute(),e,tp)
end
function c249000662.filter2(c,att,e,tp)
	return c:GetOriginalLevel() > 0 and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c249000662.filter3,tp,LOCATION_EXTRA,0,1,nil,att,c:GetOriginalLevel()+2,e,tp)
end
function c249000662.filter3(c,att,rk,e,tp)
	return (c:GetRank()==rk or c:GetRank()==rk-1) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c249000662.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000662.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000662.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsControler(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end
	local g1=Duel.SelectMatchingCard(tp,c249000662.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e:GetLabel(),e,tp)
	if g1:GetCount() > 0 and Duel.Remove(g1,POS_FACEUP,REASON_EFFECT) then
		local g2=Duel.SelectMatchingCard(tp,c249000662.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e:GetLabel(),g1:GetFirst():GetOriginalLevel()+2,e,tp)
		local sc=g2:GetFirst()
		if sc then
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			Duel.Overlay(sc,c)
			local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
			if tc2 then
				Duel.Overlay(sc,tc2)
			end
			if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP)
			and Duel.SelectYesNo(tp,aux.Stringid(16037007,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
				Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
			end
			sc:CompleteProcedure()
		end
	end
end