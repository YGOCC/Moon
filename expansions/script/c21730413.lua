--S.G. Houndspawn
function c21730413.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1160)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c21730413.reg)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--special summon token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21730413,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_END_PHASE)
	e2:SetCost(c21730413.tkcost)
	e2:SetTarget(c21730413.tktg)
	e2:SetOperation(c21730413.tkop)
	c:RegisterEffect(e2)
	--link summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21730413,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_END_PHASE)
	e3:SetTarget(c21730413.lktg)
	e3:SetOperation(c21730413.lkop)
	c:RegisterEffect(e3)
	--add from deck to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21730410,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c21730413.thcon)
	e4:SetTarget(c21730413.thtg)
	e4:SetOperation(c21730413.thop)
	c:RegisterEffect(e4)
end
--special summon token
function c21730413.tkfilter(c)
	return c:IsSetCard(0x719) and c:IsDiscardable()
end
function c21730413.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21730413.tkfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c21730413.tkfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c21730413.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,21730414,0x719,0x4011,300,200,1,RACE_BEAST,ATTRIBUTE_LIGHT,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c21730413.tkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,21730414,0x719,0x4011,300,200,1,RACE_BEAST,ATTRIBUTE_LIGHT,POS_FACEUP) then return end
	local token=Duel.CreateToken(tp,21730414)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
--link summon
function c21730413.lkfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x719)
end
function c21730413.lkfilter2(c)
	return c:IsSpecialSummonable(SUMMON_TYPE_LINK)
end
function c21730413.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21730413.lkfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c21730413.lkfilter2,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c21730413.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e)
		or not Duel.IsExistingMatchingCard(c21730413.lkfilter1,tp,LOCATION_MZONE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21730413.lkfilter2,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_LINK)
	end
end
--add from deck to hand
function c21730413.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(21730413,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c21730413.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(21730413)~=0
end
function c21730413.thfilter(c)
	return c:IsSetCard(0x719) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c21730413.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21730413.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21730413.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21730413.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end