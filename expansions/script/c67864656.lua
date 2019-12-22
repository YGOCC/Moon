--VECTOR Engineering Readiness
--Scripted by Keddy, fixed by Zerry
function c67864656.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c67864656.drtg)
    e1:SetOperation(c67864656.drop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67864656,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,67864656)
	e2:SetCondition(c67864656.spcon)
	e2:SetTarget(c67864656.sptg)
	e2:SetOperation(c67864656.spop)
	c:RegisterEffect(e2) 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69711728,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,67864656+100)
	e3:SetTarget(c67864656.target)
	e3:SetOperation(c67864656.activate)
	c:RegisterEffect(e3)
end
function c67864656.spgfilter(c,tp)
	return c:IsSetCard(0x62a6) and c:IsControler(tp)
end
function c67864656.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67864656.spgfilter,1,nil,tp)
end
function c67864656.spfilter(c,e,tp)
	return c:IsSetCard(0x2a6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67864656.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c67864656.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c67864656.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c67864656.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c67864656.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c67864656.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x62a6)
		and Duel.IsExistingTarget(c67864656.filter,tp,LOCATION_GRAVE,0,1,nil,c:GetLevel(),e,tp)
end
function c69711728.filter(c,lv,e,tp)
	return c:GetLevel()>0 and c:GetLevel()<lv and c:IsSetCard(0x2a6)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67864656.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c67864656.filter(chkc,eg:GetFirst():GetLevel(),e,tp) end
	if chk==0 then return eg:IsExists(c67864656.cfilter,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c67864656.filter,tp,LOCATION_GRAVE,0,1,1,nil,eg:GetFirst():GetLevel(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c67864656.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c67864656.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c67864656.drop(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.ShuffleHand(tp)
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end