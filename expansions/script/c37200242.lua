--Destructive Event - Light Windstorm
--Script by XGlitchy30
function c37200242.initial_effect(c)
	--choose options
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c37200242.opttg)
	e1:SetOperation(c37200242.optop)
	c:RegisterEffect(e1)
end
--filters
function c37200242.remfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToRemoveAsCost()
end
function c37200242.check_eff1(c)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE)
end
function c37200242.rem_eff1(c)
	return c:IsRace(RACE_ROCK) and c:IsAbleToRemove()
end
function c37200242.rem_eff2(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
--choose options
function c37200242.opttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,3)
		or (Duel.IsExistingMatchingCard(c37200242.remfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=0)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=0
	if Duel.IsPlayerCanDiscardDeckAsCost(tp,3) and (Duel.IsExistingMatchingCard(c37200242.remfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=0) then
		op=Duel.SelectOption(tp,aux.Stringid(37200242,0),aux.Stringid(37200242,1))
	elseif Duel.IsPlayerCanDiscardDeckAsCost(tp,3) then
		Duel.SelectOption(tp,aux.Stringid(37200242,0))
		op=0
	else
		Duel.SelectOption(tp,aux.Stringid(37200242,1))
		op=1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
	end
end
function c37200242.optop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 and Duel.IsPlayerCanDiscardDeckAsCost(tp,3) then
		Duel.DiscardDeck(tp,3,REASON_COST)
		Duel.BreakEffect()
		local dc=Duel.GetOperatedGroup()
		local mnst=dc:Filter(c37200242.check_eff1,nil)
		if mnst:GetCount()>0 and Duel.IsExistingMatchingCard(c37200242.rem_eff1,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK,mnst:GetCount(),nil) then
			local rem=Duel.SelectMatchingCard(1-tp,c37200242.rem_eff1,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK,mnst:GetCount(),mnst:GetCount(),nil)
			if rem:GetCount()>0 then
				Duel.Remove(rem,POS_FACEDOWN,REASON_EFFECT)
			end
		end
	elseif op==1 and (Duel.IsExistingMatchingCard(c37200242.remfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=0) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rcost=Duel.SelectMatchingCard(tp,c37200242.remfilter,tp,LOCATION_DECK,0,1,3,nil)
		if rcost:GetCount()>0 then
			Duel.Remove(rcost,POS_FACEUP,REASON_COST)
			local actrem=Duel.GetOperatedGroup()
			if actrem:GetCount()>0 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=actrem:GetCount() then
				Duel.ConfirmDecktop(1-tp,actrem:GetCount())
				local operated=Duel.GetDecktopGroup(1-tp,actrem:GetCount())
				if operated:GetCount()>0 then
					Duel.DisableShuffleCheck()
					local remop=operated:Filter(c37200242.rem_eff2,nil)
					if remop:GetCount()>0 then
						Duel.Remove(remop,POS_FACEUP,REASON_EFFECT)
					end
				end
			end
		end
	else return false
	end
end
			
			
		