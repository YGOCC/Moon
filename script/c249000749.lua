--Link-Mage Healer
function c249000749.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1)
	e1:SetCondition(c249000749.reccon)
	e1:SetTarget(c249000749.rectg)
	e1:SetOperation(c249000749.recop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c249000749.condition)
	e2:SetCost(c249000749.cost)
	e2:SetTarget(c249000749.target)
	e2:SetOperation(c249000749.operation)
	c:RegisterEffect(e2)
end
function c249000749.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c249000749.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*400)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*400)
end
function c249000749.recop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.Recover(tp,ct*400,REASON_EFFECT)
end
function c249000749.confilter(c)
	return c:IsSetCard(0x1EE) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000749.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c249000747.confilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>1
end
function c249000749.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c249000749.tgfilter1(c,e,tp)
	return c:IsAbleToGrave() and
	 Duel.IsExistingMatchingCard(c249000749.tgfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetOriginalLevel(),c:GetOriginalAttribute())
end
function c249000749.tgfilter2(c,e,tp,lv,att)
	return c:IsType(TYPE_LINK) and c:GetLink()<=math.ceil(lv/2) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function c249000749.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000749.tgfilter1,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000749.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c249000749.tgfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc then
		local sc=Duel.SelectMatchingCard(tp,c249000749.tgfilter2,tp,LOCATION_EXTRA,0,1,1,tc,e,tp,tc:GetOriginalLevel(),tc:GetOriginalAttribute()):GetFirst()
		if sc then
			Duel.SendtoGrave(tc,REASON_EFFECT)
			if Duel.SpecialSummonStep(sc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				sc:RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PHASE+PHASE_END)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				e2:SetCountLimit(1)
				e2:SetRange(LOCATION_MZONE)
				e2:SetCondition(c249000749.retcon)
				e2:SetOperation(c249000749.retop)
				sc:RegisterEffect(e2)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function c249000749.retcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c249000749.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
end