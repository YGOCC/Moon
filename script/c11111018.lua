--The Skydian's Verdict
function c11111018.initial_effect(c)
	--Target 1 "Skydian" monster in your GY; Special Summon that target to a zone a "Skydian" Link Monster points to, then discard 1 card.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11111018)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetTarget(c11111018.target)
	e1:SetOperation(c11111018.activate)
	c:RegisterEffect(e1)
	--You can banish this card from your GY, then target 1 "Skydian" Link Monster in your GY; Special Summon that card, then you can switch the placements of it and 1 monsters in your Extra Monster Zone.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11111018)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c11111018.sptg)
	e2:SetOperation(c11111018.spop)
	c:RegisterEffect(e2)
end
function c11111018.filter(c,e,tp,zone)
	return c:IsSetCard(0x223) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c11111018.lfilter(c)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x223)
end
function c11111018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=0
	local g=Duel.GetMatchingGroup(c11111018.lfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		zone=bit.bor(zone,tc:GetLinkedZone())
		tc=g:GetNext()
	end
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c11111018.filter(chkc,e,tp,zone) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c11111018.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone)
		and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND,0,e:GetHandler())>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c11111018.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c11111018.activate(e,tp,eg,ep,ev,re,r,rp)
	local zone=0
	local g=Duel.GetMatchingGroup(c11111018.lfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		zone=bit.bor(zone,tc:GetLinkedZone())
		tc=g:GetNext()
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
		if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then
			Duel.BreakEffect()
			Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
function c11111018.spfilter(c,e,tp)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x223) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11111018.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c11111018.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c11111018.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPS1UMMON)
	local g=Duel.SelectTarget(tp,c11111018.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c11111018.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Group.FromCards(Duel.GetFieldCard(tp,LOCATION_MZONE,5),Duel.GetFieldCard(tp,LOCATION_MZONE,6)):GetFirst()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and g and Duel.SelectYesNo(tp,aux.Stringid(11111018,0)) then
		Duel.SwapSequence(tc,g)
	end
end
