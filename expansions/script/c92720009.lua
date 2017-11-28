--Chronowitch Sun
function c92720009.initial_effect(c)
	c:EnableCounterPermit(0x2)
	c:SetCounterLimit(0x2,5)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c92720009.ctop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,92720009)
	e3:SetCondition(c92720009.spcon)
	e3:SetCost(c92720009.spcost)
	e3:SetTarget(c92720009.sptg)
	e3:SetOperation(c92720009.spop)
	c:RegisterEffect(e3)
end
function c92720009.ctop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0xf92) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x2,1)
	end
end
function c92720009.cfilter(c,tp)
	return c:IsSetCard(0xf92) and c:IsLocation(LOCATION_DECK)
		and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function c92720009.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c92720009.cfilter,1,nil,tp) and eg:GetCount()==1
end
function c92720009.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x2,2,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x2,2,REASON_COST)
end
function c92720009.filter(c,e,tp,code)
	return c:IsSetCard(0xf92) and c:IsCanBeSpecialSummoned(e,0,sp,false,false) and not c:IsCode(code)
end
function c92720009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c92720009.filter,tp,LOCATION_DECK,0,1,nil,e,tp,eg:GetFirst():GetCode())
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c92720009.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c92720009.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg:GetFirst():GetCode())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end