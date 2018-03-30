--Spy Eye
--Script by XGlitchy30
function c37200260.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,37200260+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c37200260.target)
	e1:SetOperation(c37200260.activate)
	c:RegisterEffect(e1)
end
--filters
function c37200260.rvfilter(c)
	return not c:IsPublic()
end
function c37200260.scfilter(c,lv,race)
	return c:IsType(TYPE_MONSTER) and (c:GetLevel()==lv or c:GetRace()==race)
end
--Activate
function c37200260.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37200260.rvfilter,tp,0,LOCATION_HAND,1,nil) end
end
function c37200260.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c37200260.rvfilter,tp,0,LOCATION_HAND,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(1-tp,c37200260.rvfilter,1-tp,LOCATION_HAND,0,1,1,nil)
	local rv=g:GetFirst()
	if rv then
		Duel.ConfirmCards(tp,rv)
		if rv:IsType(TYPE_MONSTER) then
			if Duel.IsExistingMatchingCard(c37200260.scfilter,tp,LOCATION_DECK,0,1,nil,rv:GetLevel(),rv:GetRace()) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sc=Duel.SelectMatchingCard(tp,c37200260.scfilter,tp,LOCATION_DECK,0,1,1,nil,rv:GetLevel(),rv:GetRace())
				if sc:GetCount()<=0 then return end
				Duel.SendtoHand(sc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sc)
			else return end
		elseif rv:IsType(TYPE_SPELL) then
			Duel.Recover(tp,2000,REASON_EFFECT)
			Duel.BreakEffect()
			Duel.SendtoDeck(rv,nil,2,REASON_EFFECT)
		elseif rv:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			rv:RegisterEffect(e1)
			if e:GetHandler():IsCanTurnSet() then
				e:GetHandler():CancelToGrave()
				Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN)
				Duel.RaiseEvent(e:GetHandler(),EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
			else
				e:GetHandler():CancelToGrave(false)
			end
		else return end
		Duel.ShuffleHand(1-tp)
	end
end