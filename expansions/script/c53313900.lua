--Rescue Hare
function c53313900.initial_effect(c)
	aux.AddOrigPandemoniumType(c)
	--P: You can activate this effect; banish this card from your Spell & Trap Zone, then add 2 Pandemonium Monster Cards with the same name from your Main Deck to your hand. You can only use this effect of "Rescue Hare" once per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetTarget(c53313900.thtg)
	e1:SetOperation(c53313900.thop)
	c:RegisterEffect(e1)
	aux.EnablePandemoniumAttribute(c,e1)
	--M: You can shuffle this card you control into the Deck; Special Summon 2 Level 4 or lower Pandemonium Monsters with the same name from your Main Deck, but they have their effects negated, also they are destroyed during the End Phase. You can only use this effect of "Rescue Hare" once per turn.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,53313900)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCost(c53313900.cost)
	e2:SetTarget(c53313900.target)
	e2:SetOperation(c53313900.operation)
	c:RegisterEffect(e2)
end
function c53313900.filter(c)
	return c:GetType()&TYPE_PANDEMONIUM==TYPE_PANDEMONIUM and c:IsAbleToHand()
end
function c53313900.filter2(c,g)
	return g:IsExists(Card.IsCode,1,c,c:GetCode())
end
function c53313900.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c53313900.filter,tp,LOCATION_DECK,0,nil)
		return e:GetHandler():IsAbleToRemove() and g:IsExists(c53313900.filter2,1,nil,g) and Duel.GetFlagEffect(tp,53313900)==0
	end
	Duel.RegisterFlagEffect(tp,53313900,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c53313900.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Remove(c,POS_FACEUP,REASON_EFFECT)==0 then return end
	local g=Duel.GetMatchingGroup(c53313900.filter,tp,LOCATION_DECK,0,nil)
	local dg=g:Filter(c53313900.filter2,nil,g)
	if dg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=dg:Select(tp,1,1,nil)
		local tc1=sg:GetFirst()
		if not tc1 then return end
		dg:RemoveCard(tc1)
		local tc2=dg:Filter(Card.IsCode,nil,tc1:GetCode()):GetFirst()
		sg:AddCard(tc2)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c53313900.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c53313900.filter1(c,e,tp)
	return c:IsLevelBelow(4) and c:GetType()&TYPE_PANDEMONIUM==TYPE_PANDEMONIUM and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c53313900.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c53313900.filter1,tp,LOCATION_DECK,0,nil,e,tp)
		return not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and Duel.GetMZoneCount(tp,e:GetHandler())>1 and g:IsExists(c53313900.filter2,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c53313900.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c53313900.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	local dg=g:Filter(c53313900.filter2,nil,g)
	if dg:GetCount()>=1 then
		local fid=e:GetHandler():GetFieldID()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=dg:Select(tp,1,1,nil)
		local tc1=sg:GetFirst()
		dg:RemoveCard(tc1)
		local tc2=dg:Filter(Card.IsCode,nil,tc1:GetCode()):GetFirst()
		sg:AddCard(tc2)
		for tc in aux.Next(sg) do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(53313900,RESET_EVENT+0x1fe0000,0,1,fid)
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
		end
		sg:KeepAlive()
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetLabel(fid)
		e3:SetLabelObject(sg)
		e3:SetCondition(c53313900.descon)
		e3:SetOperation(c53313900.desop)
		Duel.RegisterEffect(e3,tp)
	end
end
function c53313900.desfilter(c,fid)
	return c:GetFlagEffectLabel(53313900)==fid
end
function c53313900.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c53313900.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c53313900.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c53313900.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end
