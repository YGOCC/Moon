--Game Master Re-Spawn
function c12000245.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Special Summon another
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000245,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c12000245.spcon)
	e2:SetTarget(c12000245.sptg)
	e2:SetOperation(c12000245.spop)
	c:RegisterEffect(e2)
end
function c12000245.cfilter(c,tp)
	return c:IsPreviousSetCard(0x856) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_EFFECT) and not c:IsLocation(LOCATION_DECK+LOCATION_HAND)
end
function c12000245.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x856) and c:IsLevelBelow(lv) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12000245.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12000245.cfilter,1,nil,tp) and eg:GetCount()==1
		and re and re:GetHandler():IsSetCard(0x856) and re:GetHandler():IsType(TYPE_LINK)
end
function c12000245.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=eg:GetFirst():GetLevel()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12000245.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,eg:GetFirst(),e,tp,lv) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	e:SetLabel(lv)
end
function c12000245.spop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12000245.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,eg:GetFirst(),e,tp,lv)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
