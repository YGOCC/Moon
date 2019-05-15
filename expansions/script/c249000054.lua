--Xyz-Magician Dimensional Traveler
function c249000054.initial_effect(c)
	--send to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c249000054.target)
	e1:SetOperation(c249000054.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c249000054.filter(c)
	return c:IsFaceup() and not c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c249000054.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c1249000054.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000054.filter,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.SelectTarget(tp,c249000054.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c249000054.sfilter(c,e,tp)
	return c:IsSetCard(0x2073) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c249000054.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)~=0 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		if Duel.SelectYesNo(tp,2) then
			local g=Duel.SelectMatchingCard(tp,c249000054.sfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end