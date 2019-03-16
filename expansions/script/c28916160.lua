--This file was automatically coded by Kinny's Numeron Code~!
local ref=_G['c'..28916160]
local id=28916160
function ref.initial_effect(c)
	--Effect 0
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetCountLimit(1,289161600)
	e0:SetCondition(ref.sscon)
	e0:SetTarget(ref.target0)
	e0:SetOperation(ref.operation0)
	c:RegisterEffect(e0)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,289161601)
	e1:SetCost(ref.cost1)
	e1:SetTarget(ref.target1)
	e1:SetOperation(ref.operation1)
	c:RegisterEffect(e1)
end
function ref.filterE0P0(c,e,tp)
	return c:IsCode(28916161) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function ref.filterE1P0(c)
	return c:IsCanTurnSet()
end
function ref.filterE1P1(c)
	return true
end
function ref.filterE1P2(c)
	return true
end
function ref.sscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(ref.sscfilter,tp,LOCATION_ONFIELD,0,1,c,c)
end
function ref.sscfilter(c,tc)
	return c:IsFaceup() and c:IsSetCard(1856)
		and c:GetCode()~=tc:GetCode()
end
function ref.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.filterE0P0,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function ref.operation0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g0 = Duel.SelectMatchingCard(tp,ref.filterE0P0,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g0,0,tp,tp,false,false,POS_FACEUP)
end
function ref.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.filterE1P0,tp,LOCATION_MZONE,0,1,nil) end
	local g0 = Duel.SelectMatchingCard(tp,ref.filterE1P1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.ChangePosition(g0,POS_FACEDOWN_DEFENSE)
end
function ref.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0)
end
function ref.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1 = re:GetHandler()
	if Duel.NegateActivation(ev) and g1:IsRelateToEffect(re) then
		Duel.Destroy(g1,REASON_EFFECT)
	end
end
