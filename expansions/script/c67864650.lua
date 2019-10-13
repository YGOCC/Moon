--Mekbuster Peacekeeper IL9-Y2
function c67864650.initial_effect(c)
	c:EnableReviveLimit()
	--link summon
	aux.AddLinkProcedure(c,c67864650.matfilter,2)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67864650,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,67864650)
	e1:SetCondition(c67864650.thcon)
	e1:SetTarget(c67864650.thtg)
	e1:SetOperation(c67864650.thop)
	c:RegisterEffect(e1)
end
function c67864650.matfilter(c)
	return c:IsRace(RACE_MACHINE) or c:IsSetCard(0x2a6)
end
function c67864650.cfilter(c,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return ec:GetLinkedGroup():IsContains(c)
	else
		return (ec:GetLinkedZone(c:GetPreviousControler())&(1<<c:GetPreviousSequence()))~=0
	end
end
function c67864650.thfilter(c)
	return c:IsSetCard(0x2a6) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() 
end
function c67864650.thcon(e,tp,eg,ep,ev,re,r,rp)
    if eg:IsContains(e:GetHandler()) then return false end
    for tc in aux.Next(Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)) do
        if eg:IsExists(c67864650.cfilter,1,nil,tc) then return true end
    end
    return false
end
function c67864650.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67864650.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67864650.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67864650.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end