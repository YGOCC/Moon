--Chronowitch Magician
function c92720000.initial_effect(c)
	c:EnableCounterPermit(0x2)
	c:SetCounterLimit(0x2,3)
	--place counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(92720000,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(c92720000.addcon)
	e1:SetOperation(c92720000.addc)
	c:RegisterEffect(e1)
	--attackup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c92720000.attackup)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(92720000,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,92720000)
  --e3:SetCondition(c92720000.spcon)
	e3:SetCost(c92720000.spcost)
	e3:SetTarget(c92720000.sptg)
	e3:SetOperation(c92720000.spop)
	c:RegisterEffect(e3)
end
function c92720000.attackup(e,c)
	return c:GetCounter(0x2)*100
end
function c92720000.addcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x2)<3
end
function c92720000.addc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0x2,1)
	end
end
function c92720000.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x2)>=2
end
function c92720000.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c92720000.spfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf92) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(92720000)
end
function c92720000.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsPlayerAffectedByEffect(tp,92720007) and Duel.IsExistingMatchingCard(c92720000.spfilter,tp,0,LOCATION_ONFIELD,1,nil)) or e:GetHandler():IsAbleToDeckAsCost() end
	if not e:GetHandler():IsAbleToDeckAsCost() or (Duel.IsPlayerAffectedByEffect(tp,92720007) 
	and Duel.IsExistingMatchingCard(c92720000.spfilter,tp,0,LOCATION_ONFIELD,1,nil) 
	and Duel.SelectYesNo(tp,aux.Stringid(92720000,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c92720000.spfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SendtoDeck(g,nil,2,REASON_COST)
	else
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
	end
end
function c92720000.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c92720000.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c92720000.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c92720000.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		if tc:IsCanAddCounter(0x2,1) then
			tc:AddCounter(0x2,1)
		end
	end
end