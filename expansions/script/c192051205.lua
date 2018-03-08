--Steelus Lunarium
function c192051205.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(192051205,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,192051205)
	e1:SetCondition(function(e) return e:GetHandler():GetSummonLocation()==LOCATION_GRAVE end)
	e1:SetTarget(c192051205.sptg)
	e1:SetOperation(c192051205.spop)
	c:RegisterEffect(e1)
	if not c192051205.global_check then
		c192051205.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c192051205.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function c192051205.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,192051226)==0 then 
		Duel.CreateToken(tp,192051226)
		Duel.CreateToken(1-tp,192051226)
		Duel.RegisterFlagEffect(0,192051226,0,0,0)
	end
end
function c192051205.spfilter(c,e,tp)
	return c:IsSetCard(0x617) and c:GetLevel()==3 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c192051205.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
end
function c192051205.filter(c,e,tp,lv)
	return c:IsSetCard(0x617) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		and (lv==nil) or (c:GetLevel()==lv)
end
function c192051205.ritfilter(c)
	return c:IsCode(192051226) and not c:IsStatus(STATUS_DISABLED)
end
function c192051205.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c192051205.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c192051205.ritfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function c192051205.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c192051205.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		local tc=g:GetFirst()
		sg=Duel.GetMatchingGroup(c192051205.ritfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
		if sg:GetCount()<=0 then return end
		if sg:GetCount()>1 then sg=sg:Select(tp,1,1,nil) end
		Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		sg:GetFirst():CancelToGrave(false)
		c192051226.ope(e,tp,Group.FromCards(c,tc))
	end
end
