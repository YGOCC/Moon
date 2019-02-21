--Lunar Cycles
local card = c210424276
function card.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(card.target)
	e1:SetOperation(card.activate)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,210424284)
	e2:SetRange(LOCATION_GRAVE)
--	e2:SetCondition(aux.exccon)
	e2:SetCost(card.thcost)
	e2:SetTarget(card.sptg)
	e2:SetOperation(card.spop)
	c:RegisterEffect(e2)
end
function card.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function card.spfilter(c,e,tp)
	return c:IsSetCard(0x666) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function card.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local loc=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
		if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
		return loc~=0 and Duel.IsExistingMatchingCard(card.spfilter,tp,loc,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function card.spop(e,tp,eg,ep,ev,re,r,rp)
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,card.spfilter,tp,loc,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function card.cfilter2(c)
	return c:IsSetCard(0x666) and c:IsDiscardable()
end
function card.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(card.cfilter2,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function card.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,card.cfilter2,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,nil,2,REASON_EFFECT+REASON_DISCARD)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

