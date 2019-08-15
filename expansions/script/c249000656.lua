--Guardian-Caller Mage
function c249000656.initial_effect(c)
	--special summon self
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c249000656.spcon)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c249000656.cost)
	e3:SetTarget(c249000656.target)
	e3:SetOperation(c249000656.operation)
	c:RegisterEffect(e3)
end
function c249000656.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil)-Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)>=2
end
function c249000656.costfilter(c)
	return c:IsSetCard(0x2052) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c249000656.costfilter2(c,e)
	return c:IsSetCard(0x2052) and not c:IsPublic() and c:IsType(TYPE_MONSTER)
end
function c249000656.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000656.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000656.costfilter2,tp,LOCATION_HAND,0,1,c)) end
	local option
	if Duel.IsExistingMatchingCard(c249000656.costfilter2,tp,LOCATION_HAND,0,1,c)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000656.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000656.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000656.costfilter2,tp,LOCATION_HAND,0,1,c) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000656.costfilter2,tp,LOCATION_HAND,0,1,1,c)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000656.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000656.tgfilter1(c,e,tp)
	return c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c249000656.tgfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetOriginalRace())
end
function c249000656.tgfilter3(c,e,tp,rc)
	return c:IsSetCard(0x1052) and c:IsRace(rc)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c249000656.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000656.tgfilter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000656.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c249000656.tgfilter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc then
			local sc=Duel.SelectMatchingCard(tp,c249000656.tgfilter3,tp,LOCATION_EXTRA,0,1,1,tc,e,tp,tc:GetOriginalRace(),tc:GetOriginalAttribute()):GetFirst()
			if sc then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EXTRA_TOMAIN_KOISHI)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
				sc:RegisterEffect(e1)
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
				if Duel.SpecialSummonStep(sc,0,tp,tp,true,false,POS_FACEUP) then
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
					e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
					e2:SetReset(RESET_EVENT+0x1fe0000)
					sc:RegisterEffect(e2,true)
					local e3=Effect.CreateEffect(e:GetHandler())
					e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
					e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
					e3:SetCountLimit(1)
					e3:SetCondition(c249000656.retcon)
					e3:SetOperation(c249000656.retop)
					e3:SetLabel(1)
					sc:RegisterEffect(e3)
				end
				Duel.SpecialSummonComplete()
		end
	end
end
function c249000656.retcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c249000656.retop(e,tp,eg,ep,ev,re,r,rp)
	local t=e:GetLabel()
	if t==1 then e:SetLabel(0)
	else Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT) end
end