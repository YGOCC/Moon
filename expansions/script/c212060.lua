--Harpie's Bond
function c212060.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c212060.cost)
	e1:SetCountLimit(1,212060)
	e1:SetTarget(c212060.target)
	e1:SetOperation(c212060.activate)
	c:RegisterEffect(e1)
end
function c212060.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c212060.cfilter(c,tp)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c212060.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c,c:GetCode())
		and Duel.IsExistingMatchingCard(c212060.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c)
end
function c212060.filter1(c,code)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x64) and c:IsRace(RACE_WINDBEAST) and c:IsAbleToHand()
end
function c212060.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x64) and c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function c212060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c212060.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c212060.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
	e:SetLabelObject(g:GetFirst())
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c212060.activate(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c212060.filter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,sc,sc:GetCode())
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c212060.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,sc)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local gg=g2:Select(tp,1,1,nil)
	g:Merge(gg)
	if g:GetCount()==2 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local og=Duel.GetOperatedGroup():Filter(Card.IsSummonable,nil,true,nil)
		if og:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(212060,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=og:Select(tp,1,1,nil):GetFirst()
			Duel.Summon(tp,sg,true,nil)
		end
	end
end