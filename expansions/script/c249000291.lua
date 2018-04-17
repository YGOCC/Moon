--Rites-Summoner Spellkeeper
function c249000291.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75878039,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c249000291.target)
	e1:SetOperation(c249000291.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon cost
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SPSUMMON_COST)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(c249000291.spcost)
	e5:SetOperation(c249000291.spcop)
	c:RegisterEffect(e5)
end
function c249000291.filter(c)
	return c:IsSetCard(0x1AF) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c249000291.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000291.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c249000291.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c249000291.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c249000291.spcost(e,c,tp)
	return Duel.CheckReleaseGroup(tp,Card.IsRace,1,nil,RACE_SPELLCASTER)
end
function c249000291.spcop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectReleaseGroup(tp,Card.IsRace,1,1,nil,RACE_SPELLCASTER)
	Duel.Release(g,REASON_EFFECT)
end