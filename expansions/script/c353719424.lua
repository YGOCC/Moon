function c353719424.initial_effect(c)
local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c353719424.spcon2)
	e3:SetTarget(c353719424.sptg)
	e3:SetOperation(c353719424.spop)
	e3:SetCountLimit(1,353719424)
    c:RegisterEffect(e3)
--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetCountLimit(1)
	e2:SetTarget(c353719424.indtg)
	e2:SetValue(c353719424.indval)
	c:RegisterEffect(e2)
	end
		function c353719424.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c353719424.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (not c:IsRelateToEffect(e)) or Duel.GetFlagEffect(tp,353719405)>0 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c353719424.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (eg:GetCount()>0) then return false end
	if eg:IsExists(Card.IsType,1,nil,TYPE_TOKEN) then return true else return false end
end
	function c353719424.indtg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c353719424.indval(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end