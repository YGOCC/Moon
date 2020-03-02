--Nest of the Red-Eyes
--scripted by Rawstone
local s,id=GetID()
function s.initial_effect(c)
		--Activate
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_ACTIVATE)
		e1:SetCode(EVENT_FREE_CHAIN)
		c:RegisterEffect(e1)
		--shuffle to sp from Deck
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,0))
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_FZONE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetCountLimit(1)
		e2:SetTarget(s.target)
		e2:SetOperation(s.operation)
		c:RegisterEffect(e2)
		--shuffle to sp a token
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(id,1))
		e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
		e3:SetType(EFFECT_TYPE_IGNITION)
		e3:SetCode(EVENT_FREE_CHAIN)
		e3:SetCountLimit(1,id)
		e3:SetRange(LOCATION_FZONE)
		e3:SetTarget(s.tg)
		e3:SetOperation(s.op)
		c:RegisterEffect(e3)
end
	function s.thfilter(c,e,tp)
	return c:IsSetCard(0x3b) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp) and c:IsLevelBelow(7)
end
	function s.filter(c)
	return c:IsSetCard(0x3b) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
	function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,tp,CATEGORY_SPECIAL_SUMMON,1,0,0)
end
	function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,nil,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		if g:GetCount()>0 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local k=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
			Duel.SpecialSummon(k,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
	end
end
	function s.sfilter(c,e,tp)
	return c:IsSetCard(0x3b) and c:IsAbleToDeck() and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE))
end
	function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp)>0 and Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanSpecialSummonMonster(tp,2445523,0x4011,1200,700,3,RACE_DRAGON,ATTRIBUTE_DARK,nil) end
	local g=Duel.GetMatchingGroup(s.sfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,tp,CATEGORY_SPECIAL_SUMMON,1,0,0)
end
	function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_HAND+LOCATION_GRAVE,nil,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	if g:GetCount()>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,2445523,0x4011,1200,700,3,RACE_DRAGON,ATTRIBUTE_DARK,nil) then
	   local token=Duel.CreateToken(tp,2445523)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end