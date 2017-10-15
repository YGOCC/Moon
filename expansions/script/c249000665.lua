--Xyz-Knight-Summoner Chaos
function c249000665.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c249000665.condition)
	e1:SetCost(c249000665.cost2)
	e1:SetTarget(c249000665.target2)
	e1:SetOperation(c249000665.operation2)
	c:RegisterEffect(e1)
	--xyz summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,249000665)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c249000665.cost)
	e2:SetTarget(c249000665.target)
	e2:SetOperation(c249000665.operation)
	c:RegisterEffect(e2)
end
function c249000665.confilter(c)
	return c:IsSetCard(0x6073) or (bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0 and c:GetReasonEffect()
		and c:GetReasonEffect():GetHandler():IsSetCard(0x6073))
end
function c249000665.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000665.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c249000665.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c249000665.rmfilter(c)
	return c:GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c249000665.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingMatchingCard(c249000665.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c249000665.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c249000665.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c249000665.costfilter(c)
	return c:IsSetCard(0x6073) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c249000665.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c249000665.costfilter,tp,LOCATION_GRAVE,0,1,c)
		and c:IsAbleToRemoveAsCost() end
	local g=Duel.SelectMatchingCard(tp,c249000665.costfilter,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetOriginalAttribute())
end
function c249000665.filter1(c)
	return c:IsSetCard(0x6073) and c:IsType(TYPE_MONSTER)
		--and Duel.IsExistingMatchingCard(c249000665.filter2,tp,LOCATION_GRAVE,0,1,c) and c:IsAbleToRemoveAsCost()
end
function c249000665.filter2(c)
	return c:GetOriginalLevel() > 0 and c:IsAbleToRemove()
end
function c249000665.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return
	Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000665.filter1,tp,LOCATION_GRAVE,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000665.codefilter(c,code)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsCode(code)
end
function c249000665.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.SelectMatchingCard(tp,c249000665.filter2,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	local ac=Duel.AnnounceCard(tp)
	local cc=Duel.CreateToken(tp,ac)
	while not (cc:IsType(TYPE_XYZ) and (cc:GetRank()==tc:GetOriginalLevel() or cc:GetRank()==tc:GetOriginalLevel() -1) and
	cc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and cc:IsAttribute(e:GetLabel()) and not Duel.IsExistingMatchingCard(c249000665.codefilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ac))
	do
		ac=Duel.AnnounceCard(tp)
		cc=Duel.CreateToken(tp,ac)
	end
	Duel.SpecialSummon(cc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	if tc2 then
		Duel.Overlay(cc,tc2)
	end
	tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
	if tc2 then
		Duel.Overlay(cc,tc2)
	end
	cc:CompleteProcedure()
end