--Reneutrix Night Club
function c240100231.initial_effect(c)
	--When this card is activated while you control no monsters: You can Special Summon 1 "Newtrix" monster from your Deck.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c240100231.activate)
	c:RegisterEffect(e1)
	--"Newtrix" monsters do not have to activate their effects.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(240100231)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0xff,0xff)
	c:RegisterEffect(e3)
end
function c240100231.thfilter(c,e,tp)
	return c:IsSetCard(0xd10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c240100231.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c240100231.thfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g:GetCount()>0 and Duel.SelectYesNo(tp,2) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
