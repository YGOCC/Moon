--Warrior Princess Rivai, the Skydian's Valor
function c11111015.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c11111015.mfilter,2,2)
	--If this card is Link Summoned or banished (Quick Effect): You can tribute 1 LIGHT, DARK, or EARTH Warrior monster from your Deck.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,11111015)
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetTarget(c11111015.target)
	e1:SetOperation(c11111015.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c11111015.thcon)
	c:RegisterEffect(e2)
	--You can banish 1 "Skydian" monster  monster from your Extra Deck; Special Summon 1 LIGHT, DARK or EARTH Fusion, Synchro, Xyz, or Link Monster from your GY to your zone this card points to.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,11111015)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCost(c11111015.rmcost)
	e3:SetTarget(c11111015.rmtg)
	e3:SetOperation(c11111015.rmop)
	c:RegisterEffect(e3)
end
function c11111015.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK+ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR)
end
function c11111015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11111015.mfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_DECK)
end
function c11111015.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c11111015.mfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RELEASE)
		Duel.RaiseEvent(g,EVENT_RELEASE,e,r,rp,tp,0)
	end
end
function c11111015.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_LINK
end
function c11111015.rmfil(c)
	return c:IsSetCard(0x223) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c11111015.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11111015.rmfil,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11111015.rmfil,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c11111015.spfilter(c,e,tp,zone)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK+ATTRIBUTE_EARTH) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
		and (c:IsLevelBelow(7) or c:IsRankBelow(7) or c:GetLink()<=3)
end
function c11111015.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c11111015.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c11111015.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone()
	if c:IsRelateToEffect(e) and zone~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c11111015.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	end
end
