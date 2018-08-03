--Game Master Development Kit
function c12000244.initial_effect(c)
	c:SetUniqueOnField(1,0,12000244)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000244,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c12000244.spcon)
	e2:SetTarget(c12000244.sptg)
	e2:SetOperation(c12000244.spop)
	c:RegisterEffect(e2)
end
function c12000244.spfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x856) and c:IsType(TYPE_LINK)
end
function c12000244.spcon(e,c)
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12000244.spfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c12000244.spfilter2(c,e,tp,zone)
	return c:IsSetCard(0x856) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c12000244.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=Duel.GetLinkedZone(tp)
	if chkc then return chkc:IsLocation(LOCATION_HAND) and chkc:IsControler(tp) and c12000244.spfilter2(chkc,e,tp,zone) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12000244.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c12000244.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local zone=Duel.GetLinkedZone(tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12000244.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
	local tc=g:GetFirst()
	if tc:IsRelateToEffect(e) and zone~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
