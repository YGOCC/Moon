--Reverse Back
function c18917002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c18917002.sstg)
	e1:SetOperation(c18917002.ssop)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c18917002.thcost)
	e2:SetTarget(c18917002.thtg)
	e2:SetOperation(c18917002.thop)
	c:RegisterEffect(e2)
end

function c18917002.ssfilter(c,e,tp)
	return c:IsSetCard(0xb00) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENCE)
		and Duel.IsExistingMatchingCard(c18917002.ssfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetRace())
end
function c18917002.ssfilter2(c,e,tp,race)
	return c:IsSetCard(0xb00) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsRace(race)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENCE)
end
function c18917002.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c18917002.ssfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c18917002.ssop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c18917002.ssfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local g2=Duel.SelectMatchingCard(tp,c18917002.ssfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g:GetFirst():GetRace())
		g:Merge(g2)
		if g:GetCount()==2 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
		end
	end
end

function c18917002.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
end
function c18917002.thfilter(c)
	return c:IsSetCard(0xb00) and c:IsType(TYPE_MONSTER)
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and c:IsAbleToHand()
end
function c18917002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18917002.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c18917002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c18917002.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
