--Cupillar of Fiber VINE
function c16000129.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c16000129.spcon)
	c:RegisterEffect(e1) 
		--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16000129,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(2,16000129)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c16000129.target)
	e2:SetOperation(c16000129.operation)
	c:RegisterEffect(e2)
end

-- SpecialSummon from hand
function c16000129.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x185a) or c:IsCode(16000129)
end
function c16000129.spcon(e,c)
	  return not Duel.IsExistingMatchingCard(c16000129.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c16000129.filter(c,e,sp)
	return c:IsSetCard(0x185a) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c16000129.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16000129.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c16000129.operation(e,tp,eg,ep,ev,re,r,rp)

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16000129.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
