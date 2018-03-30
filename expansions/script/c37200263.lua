--Evolsaur Anthrulus
--Script by XGlitchy30
function c37200263.initial_effect(c)
	--spsummon rep
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37200263,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,37200263)
	e1:SetTarget(c37200263.sptg)
	e1:SetOperation(c37200263.spop)
	c:RegisterEffect(e1)
	--spsummon din
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(37200263,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,31200263)
	e2:SetCondition(c37200263.spscon)
	e2:SetTarget(c37200263.spstg)
	e2:SetOperation(c37200263.spsop)
	c:RegisterEffect(e2)
end
--filters
function c37200263.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_REPTILE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp)
end
function c37200263.cfilter(c,e,tp)
	return c:IsRace(RACE_DINOSAUR) and Duel.IsExistingMatchingCard(c37200263.spsfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and ((c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or (c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1))
end
function c37200263.spsfilter(c,e,tp)
	return (c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_DINOSAUR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP))
		or (c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_DINOSAUR) and c:IsSetCard(0x604e) and c:IsCanBeSpecialSummoned(e,170,tp,false,false))
end
--spsummon rep
function c37200263.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0)
		and Duel.IsExistingMatchingCard(c37200263.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	--field check
	local fd1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c37200263.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local fd2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c37200263.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(93130021,0))
	if fd1 and fd2 then
		op=Duel.SelectOption(tp,aux.Stringid(37200263,2),aux.Stringid(37200263,3))
	elseif fd1 then
		op=Duel.SelectOption(tp,aux.Stringid(37200263,2))
	elseif fd2 then
		op=Duel.SelectOption(tp,aux.Stringid(37200263,3))+1
	else return end
	e:SetLabel(op)
	if op==0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	elseif op==1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	else return end
end
function c37200263.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsExistingMatchingCard(c37200263.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c37200263.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	elseif e:GetLabel()==1 then
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 or not Duel.IsExistingMatchingCard(c37200263.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c37200263.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
		end
	else return end
end
--spsummon din
function c37200263.spscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c37200263.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c37200263.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c37200263.spsop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c37200263.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.Destroy(g,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sp=Duel.SelectMatchingCard(tp,c37200263.spsfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			local sps=sp:GetFirst()
			if sps:IsSetCard(0x604e) and sps:IsCanBeSpecialSummoned(e,170,tp,false,false) then
				Duel.SpecialSummon(sps,170,tp,tp,false,false,POS_FACEUP)
				local rf=sps.evolreg
				if rf then 
					rf(sps) 
				end
			else
				Duel.SpecialSummon(sps,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
