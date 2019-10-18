--VECTOR Energy Core
--Scripted by Zerry
function c67864668.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c67864668.matfilter,1,1)
--Search Field Spell
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67864668,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,67864668)
	e1:SetCondition(c67864668.thcon)
	e1:SetTarget(c67864668.thtg)
	e1:SetOperation(c67864668.thop)
	c:RegisterEffect(e1)
--Link Restriction
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c67864668.limit)
	c:RegisterEffect(e2)
end
--Summoning Condition Filter
function c67864668.matfilter(c)
	return c:IsSetCard(0x2a6) and not c:IsType(TYPE_LINK) and not c:IsSetCard(0x62a6)
end
--Link Restriction
function c67864668.limit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x2a6)
end
--Search Filter
function c67864668.thfilter(c)
	return c:IsSetCard(0x2a6) and c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
--Search Effect
function c67864668.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c67864668.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67864668.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67864668.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67864668.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end