--overdrive
--coded by Concordia
function c68709324.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,68709324)
	e1:SetTarget(c68709324.target)
	e1:SetOperation(c68709324.activate)
	c:RegisterEffect(e1)
end
function c68709324.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf08) and c:IsAbleToGrave()
end
function c68709324.filter(c,e,tp)
	return c:IsSetCard(0xf09) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c68709324.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c68709324.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c68709324.cfilter,tp,LOCATION_MZONE,0,2,nil) end
	local g=Duel.SelectTarget(tp,c68709324.cfilter,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TO_GRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(1,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c68709324.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoGrave(tc,nil,REASON_EFFECT)
	local g=Duel.SelectMatchingCard(tp,c68709324.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end