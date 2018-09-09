--S.G. Houndspawn
function c21730410.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--special summon token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21730410,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_END_PHASE)
	e2:SetCost(c21730410.tkcost)
	e2:SetTarget(c21730410.tktg)
	e2:SetOperation(c21730410.tkop)
	c:RegisterEffect(e2)
	--link summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21730410,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_END_PHASE)
	e3:SetTarget(c21730410.lktg)
	e3:SetOperation(c21730410.lkop)
	c:RegisterEffect(e3)
end
--special summon token
function c21730410.tkfilter(c)
	return c:IsSetCard(0x719) and c:IsDiscardable()
end
function c21730410.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21730410.tkfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c21730410.tkfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c21730410.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,21730411,0x719,0x4011,300,200,1,RACE_BEAST,ATTRIBUTE_LIGHT,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c21730410.tkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,21730411,0x719,0x4011,300,200,1,RACE_BEAST,ATTRIBUTE_LIGHT,POS_FACEUP) then return end
	local token=Duel.CreateToken(tp,21730411)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
--link summon
function c21730410.lkfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x719)
end
function c21730410.lkfilter2(c)
	return c:IsSpecialSummonable(SUMMON_TYPE_LINK)
end
function c21730410.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21730410.lkfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c21730410.lkfilter2,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c21730410.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e)
		or not Duel.IsExistingMatchingCard(c21730410.lkfilter1,tp,LOCATION_MZONE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21730410.lkfilter2,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_LINK)
	end
end