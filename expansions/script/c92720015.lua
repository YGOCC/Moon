--Chronowitch Temperance
function c92720015.initial_effect(c)
	c:EnableCounterPermit(0x2)
	c:SetCounterLimit(0x2,3)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c92720015.spcon)
	e1:SetTarget(c92720015.sptg)
	e1:SetOperation(c92720015.spop)
	c:RegisterEffect(e1)
	--place counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(92720015,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c92720015.addcon)
	e2:SetOperation(c92720015.addc)
	c:RegisterEffect(e2)
	--attackup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c92720015.attackup)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(92720015,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,92720015)
	e4:SetCondition(c92720015.spcon1)
	e4:SetCost(c92720015.spcost1)
	e4:SetTarget(c92720015.sptg1)
	e4:SetOperation(c92720015.spop1)
	c:RegisterEffect(e4)
end
function c92720015.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c92720015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x2)
end
function c92720015.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		e:GetHandler():AddCounter(0x2,1)
	end
end
function c92720015.attackup(e,c)
	return c:GetCounter(0x2)*700
end
function c92720015.addcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x2)<3
end
function c92720015.addc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0x2,1)
	end
end
function c92720015.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x2)>=2
end
function c92720015.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c92720015.spfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf92) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(92720015)
end
function c92720015.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsPlayerAffectedByEffect(tp,92720007) and Duel.IsExistingMatchingCard(c92720015.spfilter,tp,0,LOCATION_ONFIELD,1,nil)) or e:GetHandler():IsAbleToDeckAsCost() end
	if not e:GetHandler():IsAbleToDeckAsCost() or (Duel.IsPlayerAffectedByEffect(tp,92720007) 
	and Duel.IsExistingMatchingCard(c92720015.spfilter,tp,0,LOCATION_ONFIELD,1,nil) 
	and Duel.SelectYesNo(tp,aux.Stringid(92720015,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c92720015.spfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SendtoDeck(g,nil,2,REASON_COST)
	else
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
	end
end
function c92720015.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c92720015.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c92720015.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xf92)
end
function c92720015.spop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c92720015.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
	local g=Duel.GetMatchingGroup(c92720015.filter,tp,LOCATION_ONFIELD,0,nil)
	if g:GetCount()==0 then return end
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=g:Select(tp,1,1,nil)
		sg:GetFirst():AddCounter(0x2,1)
		end
	end
end