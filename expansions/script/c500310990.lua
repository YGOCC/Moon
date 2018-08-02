--Sweethard Mumy double Boots
function c500310990.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,c500310990.matfilter,2,2)
	c:EnableReviveLimit()

			--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,500310990)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c500310990.thcon)
	e2:SetTarget(c500310990.thtg)
	e2:SetOperation(c500310990.thop)
	c:RegisterEffect(e2)
end
function c500310990.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c500310990.matfilter(c)
	return c:IsLinkRace(RACE_BEASTWARRIOR) or c:IsLinkAttribute(ATTRIBUTE_DARK)
end

function c500310990.thfilter(c)
	return c:IsLevelBelow(4) and c:IsRace(RACE_BEASTWARRIOR) and c:IsAbleToHand()
end
function c500310990.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c500310990.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c500310990.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c500310990.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end