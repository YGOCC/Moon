--Galaxy Kitsune Hero LV6
function c249000484.initial_effect(c)
	--special summon lvup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75830094,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCondition(c249000484.spcon2)
	e1:SetCost(c249000484.spcost2)
	e1:SetTarget(c249000484.sptg2)
	e1:SetOperation(c249000484.spop2)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(652362,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,249000484)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c249000484.cost)
	e2:SetTarget(c249000484.target)
	e2:SetOperation(c249000484.operation)
	c:RegisterEffect(e2)
end
c249000484.lvupcount=1
c249000484.lvup={249000485}
c249000484.lvdncount=1
c249000484.lvdn={249000483}
function c249000484.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function c249000484.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c249000484.spfilter2(c,e,tp)
	return c:IsCode(249000485) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c249000484.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c249000484.spfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c249000484.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c249000484.spfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c249000484.costfilter(c)
	return (c:IsSetCard(0x7B) or c:IsSetCard(0x1CB)) and c:IsAbleToRemoveAsCost()
end
function c249000484.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000484.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000484.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000484.filter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToRemove()
end
function c249000484.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c249000484.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,e:GetHandler(),TYPE_MONSTER) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c249000484.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,1,e:GetHandler(),TYPE_MONSTER):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	local rmg=Duel.SelectMatchingCard(tp,c249000484.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,99,e:GetHandler(),TYPE_MONSTER)
	Duel.Remove(rmg,POS_FACEUP,REASON_EFFECT)
	local lvto=rmg:GetSum(Card.GetLevel)
	local ac=Duel.AnnounceCard(tp)
	local cc=Duel.CreateToken(tp,ac)
	while not ((cc:GetLevel()<=lvto or cc:GetRank()<=lvto) and
	(cc:GetLevel()<=7 or cc:GetRank()<=7) and
	cc:IsRace(tc:GetRace()) and cc:IsAttribute(tc:GetAttribute()) and
	((cc:IsType(TYPE_SYNCHRO) and cc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false))
	or (cc:IsType(TYPE_XYZ) and cc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false))))
	do
		ac=Duel.AnnounceCard(tp)
		cc=Duel.CreateToken(tp,ac)
	end
	if cc:IsType(TYPE_SYNCHRO) then Duel.SpecialSummon(cc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	else
		if Duel.SpecialSummon(cc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) then
			local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
			if tc2 then
				Duel.Overlay(cc,tc2)
			end
			tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
			if tc2 then
				Duel.Overlay(cc,tc2)
			end
		end
	end
end