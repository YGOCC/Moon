--[]
--[]
function c39336818.initial_effect(c)
	--Spirit Return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--Cannot Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,39336818)
	e2:SetCondition(c39336818.negcon1)
	e2:SetCost(c39336818.negcost)
	e2:SetTarget(c39336818.negtg)
	e2:SetOperation(c39336818.negop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCondition(c39336818.negcon2)
	c:RegisterEffect(e3)
	--Search & Normal Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(39336818,1))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c39336818.thtg)
	e4:SetOperation(c39336818.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP)
	c:RegisterEffect(e5)
end
function c39336818.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x125)
end
function c39336818.negcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c39336818.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c39336818.negcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c39336818.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c39336818.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c39336818.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c39336818.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end
function c39336818.thfilter(c)
	return c:IsSetCard(0x125) and not c:IsCode(39336818) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c39336818.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c39336818.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c39336818.sumfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsSummonable(true,nil)
end
function c39336818.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c39336818.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local og=Duel.GetMatchingGroup(c39336818.sumfilter,tp,LOCATION_HAND,0,nil)
		if og:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(39336818,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=og:Select(tp,1,1,nil):GetFirst()
			Duel.ShuffleHand(tp)
			Duel.Summon(tp,sg,true,nil)
		end
	end
end

--function c39336818.thop(e,tp,eg,ep,ev,re,r,rp)
--	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
--	local g=Duel.SelectMatchingCard(tp,c39336818.thfilter,tp,LOCATION_DECK,0,1,1,nil)
--	if g:GetCount()>0 then
--		Duel.SendtoHand(g,nil,REASON_EFFECT)
--		Duel.ConfirmCards(1-tp,g)
--	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(39336818,0)) then
--			Duel.BreakEffect()
--			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
--			local sc=g:Select(tp,1,1,nil):GetFirst()
--			Duel.ShuffleHand(tp)
--			Duel.Summon(tp,sc,true,nil)
--		else
--			Duel.ShuffleHand(tp)
--		end
--	end
--end
--(works but doesn't let you SS any monster, just the original target)