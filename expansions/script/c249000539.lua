--Synchro-Conveter Conversion
function c249000539.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,249000539)
	e1:SetCost(c249000539.cost)
	e1:SetTarget(c249000539.target)
	e1:SetOperation(c249000539.activate)
	c:RegisterEffect(e1)
end
function c249000539.costfilter(c)
	return c:IsSetCard(0x1CA) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c249000539.costfilter2(c,e)
	return c:IsSetCard(0x1CA) and c:IsType(TYPE_MONSTER) and not c:IsPublic() and c~=e:GetHandler()
end
function c249000539.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000539.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000539.costfilter2,tp,LOCATION_HAND,0,1,nil,e)) end
	local option
	if Duel.IsExistingMatchingCard(c249000539.costfilter2,tp,LOCATION_HAND,0,1,nil,e)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000539.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000539.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000539.costfilter2,tp,LOCATION_HAND,0,1,nil,e) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000539.costfilter2,tp,LOCATION_HAND,0,1,1,nil,e)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000539.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000539.filter1(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemove()
end
function c249000539.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c249000539.filter1(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c249000539.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c249000539.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c249000539.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tc=Duel.GetFirstTarget()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=1 then return end
	local lv=tc:GetLevel()
	local att=tc:GetAttribute()
	local race=tc:GetRace()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	ac=Duel.AnnounceCard(tp)
	sc=Duel.CreateToken(tp,ac)
	while not (sc:IsType(TYPE_SYNCHRO) and sc:GetLevel() and  math.abs(lv - sc:GetLevel()) <= 2 and sc:IsRace(race)
	and sc:IsAttribute(att) and sc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and sc:GetCode()~=tc:GetCode())
	do
		ac=Duel.AnnounceCard(tp)
		sc=Duel.CreateToken(tp,ac)
		if sc:IsType(TYPE_TRAP) then return end
	end
	if sc then
		Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end