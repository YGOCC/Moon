--Azure Paladin's Trials of Knighthood
function c249001004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(249001004+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c249001004.target)
	e1:SetOperation(c249001004.activate)
	c:RegisterEffect(e1)
end
function c249001004.filter(c,e,tp)
	return c:IsSetCard(0x200) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c249001004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c249001004.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c249001004.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c249001004.filter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c249001004.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if g:GetCount()<=ct then
		if g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)<1 then return end
	end
	Duel.BreakEffect()
	if Duel.GetLocationCountFromEx(tp,tp,g)<=0 then return end
	local g2=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g2:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	else
		Duel.ConfirmCards(1-tp,Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_EXTRA,0,nil))
	end
end