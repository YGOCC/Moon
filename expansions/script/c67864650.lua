--Mekbuster Peacekeeper IL9-Y2
function c67864650.initial_effect(c)
	c:EnableReviveLimit()
	--link summon
	aux.AddLinkProcedure(c,c67864650.matfilter,2)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,67864650)
	e1:SetCondition(aux.zptcon(nil))
	e1:SetTarget(c67864650.thtg)
	e1:SetOperation(c67864650.thop)
	c:RegisterEffect(e1)
	--To Grave + Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67864650,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,67864650+100)
	e2:SetCondition(c67864650.tgcon)
	e2:SetTarget(c67864650.tgtg)
	e2:SetOperation(c67864650.tgop)
	c:RegisterEffect(e2)
end
function c67864650.matfilter(c)
	return c:IsRace(RACE_MACHINE) or c:IsSetCard(0x2a6)
end

function c67864650.thfilter(c)
	return c:IsSetCard(0x2a6) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() 
end
function c67864650.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67864650.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67864650.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67864650.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c67864650.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x12a6)
end
function c67864650.tgcon(e)
	return not Duel.IsExistingMatchingCard(c67864650.desfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function c67864650.spfilter(c,e,tp)
	return c:IsSetCard(0x12a6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67864650.tgfilter(c,lg)
	return c:IsAbleToGrave() and lg:IsContains(c)
end
function c67864650.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(c67864650.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c67864650.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lg) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,lg,lg:GetCount(),0,0)
end
function c67864650.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup():Filter(Card.IsAbleToGrave,nil)
	if Duel.SendtoGrave(lg,nil,REASON_EFFECT)~=0 then
		local g1=Duel.SelectMatchingCard(tp,c67864650.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end