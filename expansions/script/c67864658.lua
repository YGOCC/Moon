--VECTOR Engineer Salvatore
--Scripted by Zerry
function c67864658.initial_effect(c)
--link summon
	aux.AddLinkProcedure(c,c67864658.lfilter,2,4)
	c:EnableReviveLimit()
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(42023223,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(c67864658.spcon)
	e3:SetCost(c67864658.spcost)
	e3:SetTarget(c67864658.sptg)
	e3:SetOperation(c67864658.spop)
	c:RegisterEffect(e3)
end
function c67864658.lfilter(c)
	return c:IsLinkSetCard(0x62a6)
end
function c67864658.cfilter(c)
	return c:IsSetCard(0x2a6) and c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c67864658.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67864658.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c67864658.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c67864658.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c67864658.spfilter(c,e,tp)
	return c:IsSetCard(0x62a6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67864658.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c67864658.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c67864658.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c67864658.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c67864658.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c67864658.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end