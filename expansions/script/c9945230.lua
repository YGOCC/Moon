--Sin & Virtue, Collapse
function c9945230.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9945230+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9945230.target)
	e1:SetOperation(c9945230.activate)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(9945230,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c9945230.thcost)
	e2:SetTarget(c9945230.thtg)
	e2:SetOperation(c9945230.thop)
	c:RegisterEffect(e2)
end
function c9945230.cfilter1(c,e,tp)
	return (c:IsSetCard(0x204F) or c:IsSetCard(0x2050)) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c9945230.cfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c9945230.cfilter2(c,e,tp,tc)
	return (c:IsSetCard(0x204F) or c:IsSetCard(0x2050)) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TUNER) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c9945230.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,c:GetLevel()+tc:GetLevel())
end
function c9945230.spfilter(c,e,tp,lv)
	return (c:IsSetCard(0x204F) or c:IsSetCard(0x2050)) and c:IsType(TYPE_RITUAL) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c9945230.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsExistingMatchingCard(c9945230.cfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9945230.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c9945230.cfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c9945230.cfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,g1:GetFirst())
	e:SetLabel(g1:GetFirst():GetLevel()+g2:GetFirst():GetLevel())
	Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	Duel.SendtoGrave(g2,nil,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9945230.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	if tc then
		tc:SetMaterial(nil)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c9945230.rmfilter(c)
	return c:IsSetCard(0x204F) or c:IsSetCard(0x2050) and c:IsAbleToRemoveAsCost()
end
function c9945230.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c9945230.rmfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9945230.rmfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9945230.thfilter(c)
	return c:IsType(TYPE_RITUAL) or c:IsCode(9945320) or c:IsCode(9945325) and c:IsAbleToHand()
end
function c9945230.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c9945230.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9945230.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9945230.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end