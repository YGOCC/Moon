--Game Master's Charity
function c12000243.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000243,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,12000243)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c12000243.sptg)
	e2:SetOperation(c12000243.spop)
	c:RegisterEffect(e2)
end
function c12000243.spfilter1(c,e,tp)
	local lk=c:GetLink()
	return lk>0 and c:IsSetCard(0x856) and c:IsType(TYPE_LINK)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and Duel.IsExistingMatchingCard(c12000243.spfilter2,tp,LOCATION_GRAVE,0,lk,nil)
end
function c12000243.spfilter12(c,e,tp)
	local lk=c:GetLink()
	return lk>0 and c:IsSetCard(0x856) and c:IsType(TYPE_LINK)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c12000243.spfilter2(c)
	return c:IsSetCard(0x856) and c:IsType(TYPE_LINK) and c:IsAbleToRemoveAsCost()
end
function c12000243.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12000243.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c12000243.spfilter12,tp,LOCATION_EXTRA,0,nil,e,tp)
	local lkt={}
	local tc=g:GetFirst()
	while tc do
		local tlk=tc:GetLink()
		lkt[tlk]=tlk
		tc=g:GetNext()
	end
	local pc=1
	for i=2,4 do
		if lkt[i] then lkt[i]=nil lkt[pc]=i pc=pc+1 end
	end
	lkt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12000243,1))
	local lk=Duel.AnnounceNumber(tp,table.unpack(lkt))
	local g=Duel.SelectMatchingCard(tp,c12000243.spfilter2,tp,LOCATION_GRAVE,0,lk,lk,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(lk)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c12000243.spfilter3(c,lk,e,tp)
	return c:IsLocation(LOCATION_EXTRA) and c:IsLink(lk)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c12000243.spop(e,tp,eg,ep,ev,re,r,rp)
	local lk=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12000243.spfilter3,tp,LOCATION_EXTRA,0,1,1,nil,lk,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end