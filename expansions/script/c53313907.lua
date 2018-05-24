--Mysterious Starquid
function c53313907.initial_effect(c)
	aux.AddOrigPandemoniumType(c)
	--P-When an effect is activated: You can destroy this card, and change that effect to "Both players can add 1 level 7 or lower Pandemonium monster from their Decks to their hands.".
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetTarget(c53313907.chtg)
	e1:SetOperation(c53313907.chop)
	c:RegisterEffect(e1)
	aux.EnablePandemoniumAttribute(c,e1)
	--M-When this card is Summoned: You can add 1 "Mysterious" monster from your Deck, Extra Deck or GY to your Hand.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetTarget(c53313907.thtg)
	e2:SetOperation(c53313907.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--M-When this card leaves the field: You can set 1 "Mysterious" Pandemonium monster directly from your Deck to your Spell & Trap card zone except "Mysterious Starquid".
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetTarget(c53313907.settg)
	e5:SetOperation(c53313907.setop)
	c:RegisterEffect(e5)
end
function c53313907.filter(c)
	return c:IsLevelBelow(7) and c:GetType()&TYPE_PANDEMONIUM==TYPE_PANDEMONIUM
end
function c53313907.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if not re then
		ev=Duel.GetCurrentChain()-1
		re=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
	end
	if chk==0 then return ev>0 and e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c53313907.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c53313907.chop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.Destroy(e:GetHandler(),REASON_EFFECT)==0 then return end
	if not re then
		ev=math.max(Duel.GetCurrentChain()-1,1)
		re=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
	end
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c53313907.repop)
end
function c53313907.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():CancelToGrave(false)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c53313907.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc1=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(1-tp,c53313907.filter,tp,0,LOCATION_DECK,1,1,nil)
	local tc2=g2:GetFirst()
	g1:Merge(g2)
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	if tc1 then Duel.ConfirmCards(1-tp,tc1) end
	if tc2 then Duel.ConfirmCards(tp,tc2) end
end
function c53313907.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcf6) and c:IsAbleToHand()
end
function c53313907.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53313907.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c53313907.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c53313907.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c53313907.setfilter(c)
	return c:IsSetCard(0xcf6) and c:GetType()&TYPE_PANDEMONIUM==TYPE_PANDEMONIUM and c:IsType(TYPE_MONSTER)
end
function c53313907.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SSET)
		and Duel.IsExistingMatchingCard(c53313907.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c53313907.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,1601)
	local g=Duel.SelectMatchingCard(tp,c53313907.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		aux.PandSSet(tc,REASON_EFFECT)(e,tp,eg,ep,ev,re,r,rp)
		Duel.ConfirmCards(1-tp,tc)
	end
end
