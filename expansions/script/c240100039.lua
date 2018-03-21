--created & coded by Lyris, art at http://www.uppicweb.com/x/i/it/136369.jpg
--襲雷大降り
function c240100039.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(122518919,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,240100039)
	e2:SetCondition(c240100039.spcon2)
	e2:SetCost(c240100039.spcost)
	e2:SetTarget(c240100039.sptg2)
	e2:SetOperation(c240100039.spop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetRange(LOCATION_SZONE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c240100039.desop)
	c:RegisterEffect(e1)
end
function c240100039.desfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and not c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT+ATTRIBUTE_WIND) and not c:IsTypeCustom("Spatial")
end
function c240100039.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c240100039.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c240100039.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c240100039.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c240100039.cfilter,1,nil,tp)
end
function c240100039.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,240100039)==0 end
	Duel.RegisterFlagEffect(tp,240100039,RESET_PHASE+PHASE_END,0,1)
end
function c240100039.filter(c,e,tp)
	return c:IsSetCard(0x7c4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c240100039.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c240100039.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c240100039.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,240100039)==0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c240100039.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
