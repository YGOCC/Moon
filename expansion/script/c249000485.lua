--Galaxy Kitsune Hero LV8
function c249000485.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(652362,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,249000485)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c249000485.cost)
	e2:SetTarget(c249000485.target)
	e2:SetOperation(c249000485.operation)
	c:RegisterEffect(e2)
	--immune spell
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c249000485.efilter)
	c:RegisterEffect(e3)
end
c249000485.lvdncount=2
c249000485.lvdn={249000427,249000428}
function c249000485.costfilter(c)
	return (c:IsSetCard(0x7B) or c:IsSetCard(0x1CB)) and c:IsAbleToRemoveAsCost()
end
function c249000485.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000485.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000485.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000485.filter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToRemove()
end
function c249000485.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c249000485.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,e:GetHandler(),TYPE_MONSTER) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c249000485.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,1,e:GetHandler(),TYPE_MONSTER):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	local rmg=Duel.SelectMatchingCard(tp,c249000485.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,99,e:GetHandler(),TYPE_MONSTER)
	Duel.Remove(rmg,POS_FACEUP,REASON_EFFECT)
	local lvto=rmg:GetSum(Card.GetLevel)
	local ac=Duel.AnnounceCard(tp)
	local cc=Duel.CreateToken(tp,ac)
	while not ((cc:GetLevel()<=lvto or cc:GetRank()<=lvto) and
	cc:IsRace(tc:GetRace()) and cc:IsAttribute(tc:GetAttribute()) and
	( not (cc:GetRank()==10 and cc:IsRace(RACE_WINDBEAST))) and
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
function c249000485.efilter(e,te)
	return (te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_TRAP)) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end