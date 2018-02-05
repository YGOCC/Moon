--insect#1
function c28000.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,28000)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c28000.spcon)
	c:RegisterEffect(e1)
	--spsummon deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28000,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,28000)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c28000.spcost)
	e2:SetTarget(c28000.sptg)
	e2:SetOperation(c28000.spop)
	c:RegisterEffect(e2)
end	
c28000.lvupcount=1
c28000.lvup={28001}
	
function c28000.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x41)
end
function c28000.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and	Duel.IsExistingMatchingCard(c28000.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function c28000.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c28000.spfilter(c,e,tp)
	return c:IsCode(28001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c28000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c28000.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c28000.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c28000.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
