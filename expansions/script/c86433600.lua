--Extracostly Activation
--Script by XGlitchy30
function c86433600.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,86433600+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c86433600.replacecon)
	e1:SetTarget(c86433600.target)
	c:RegisterEffect(e1)
	--activate cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCondition(c86433600.costcon)
	e2:SetTarget(c86433600.costtarget)
	e2:SetCost(c86433600.costchk)
	e2:SetOperation(c86433600.costop)
	c:RegisterEffect(e2)
	--accumulate cost
	local e2y=Effect.CreateEffect(c)
	e2y:SetType(EFFECT_TYPE_FIELD)
	e2y:SetCode(0x10000000+86433600)
	e2y:SetRange(LOCATION_SZONE)
	e2y:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2y:SetTargetRange(1,1)
	c:RegisterEffect(e2y)
end
--filters
function c86433600.spfilter(c,e,tp)
	return c:GetLevel()>0 and c:GetLevel()<=4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c86433600.cfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA
end
function c86433600.costfilter(c,card)
	return c:IsAbleToRemoveAsCost() and (not card or c~=card)
end
--Activate
function c86433600.replacecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(87433600)<=0
end
function c86433600.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98935722.spfilter(chkc,e,tp) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(c86433600.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(86433600,0)) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c86433600.activate)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(c86433600.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c86433600.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		Duel.SpecialSummonComplete()
	end
end
--activate cost
function c86433600.costcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)~=0 and not Duel.IsExistingMatchingCard(c86433600.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
		and e:GetHandler():GetFlagEffect(87433600)<=0
end
function c86433600.costtarget(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_QUICK_O+EFFECT_TYPE_QUICK_F+EFFECT_TYPE_IGNITION)
end
function c86433600.costchk(e,te_or_c,tp)
	if not te_or_c then return true end
	local ct=Duel.GetFlagEffect(tp,86433600)
	local exc=te_or_c:GetHandler()
	local g=Duel.GetMatchingGroup(c86433600.costfilter,tp,LOCATION_HAND,0,exc,exc)
	return g:GetCount()>=ct
end
function c86433600.costop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c86433600.costfilter,tp,LOCATION_HAND,0,nil,nil)
	if g:GetCount()>0 then
		for exc in aux.Next(g) do
			if not exc:IsLocation(LOCATION_HAND) then
				if g:IsContains(exc) then
					g:RemoveCard(exc)
				end
			elseif exc:IsStatus(STATUS_CHAINING) then
				local chain=Duel.GetCurrentChain()
				if chain==0 then
					if g:IsContains(exc) then
						g:RemoveCard(exc)
					end
					exc:RegisterFlagEffect(83433600,RESET_CHAIN,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE,1)
				else
					if exc:GetFlagEffect(83433600)<=0 then
						if g:IsContains(exc) then
							g:RemoveCard(exc)
						end
						exc:RegisterFlagEffect(83433600,RESET_CHAIN,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE,1)
					end
				end
			end
		end
		local rg=g:RandomSelect(tp,1)
		local tc=rg:GetFirst()
		if tc:IsAbleToRemoveAsCost() then
			Duel.Remove(tc,POS_FACEUP,REASON_COST)
			tc:RegisterFlagEffect(86433600,RESET_EVENT+RESETS_STANDARD,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(86433600,2))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabel(tc:GetControler())
			e1:SetLabelObject(tc)
			e1:SetCondition(c86433600.retcon)
			e1:SetOperation(c86433600.retop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c86433600.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(86433600)==0 then
		e:Reset()
		return false
	else
		return true
	end
end
function c86433600.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,e:GetLabel(),REASON_EFFECT)
end