--Future City
function c1020025.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1020025+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1020025.target)
	e1:SetOperation(c1020025.activate)
	c:RegisterEffect(e1)
	--maintain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c1020025.mtop)
	e2:SetTarget(c1020025.tg)
	e2:SetOperation(c1020025.op)
	c:RegisterEffect(e2)
end
function c1020025.filter(c)
	return c:IsSetCard(0xded) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToHand() and not c:IsCode(1020025)
end
function c1020025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1020025.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1020025.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1020025.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c1020025.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1ded) and c:IsAbleToDeckOrExtraAsCost()
end
function c1020025.mtop(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1020025.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1020025.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c1020025.spfilter(c,e,tp)
	return c:IsSetCard(0x1ded) and c:GetLevel()==7 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1020025.addfilter(c)
	return c:IsSetCard(0x1ded) and c:GetLevel()==3 and c:IsAbleToHand()
end
function c1020025.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local sel=0
		if Duel.IsExistingMatchingCard(c1020025.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) then sel=sel+1 end
		if Duel.IsExistingMatchingCard(c1020025.addfilter,tp,LOCATION_DECK,0,1,nil) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1020025,0))
		sel=Duel.SelectOption(tp,aux.Stringid(1020025,0),aux.Stringid(1020025,1))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(1020025,0))
	else
		Duel.SelectOption(tp,aux.Stringid(1020025,1))
	end
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c1020025.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		local g=Duel.GetMatchingGroup(c1020025.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local dg=g:Select(tp,1,1,nil)
			Duel.HintSelection(dg)
			Duel.SpecialSummon(dg,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1020025.addfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
