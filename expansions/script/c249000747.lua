--Link-Mage Master
function c249000747.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c249000747.spcon)
	e1:SetOperation(c249000747.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c249000747.condition)
	e2:SetTarget(c249000747.target)
	e2:SetOperation(c249000747.operation)
	c:RegisterEffect(e2)
end
function c249000747.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),Card.IsType,1,nil,TYPE_LINK)
end
function c249000747.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),Card.IsType,1,1,nil,TYPE_LINK)
	Duel.Release(g,REASON_COST)
end
function c249000747.confilter(c)
	return c:IsSetCard(0x1EE) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000747.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c249000747.confilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>1
end
function c249000747.tgfilter1(c,e,tp)
	return c:IsAbleToRemove() and
	 Duel.IsExistingMatchingCard(c249000747.tgfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetOriginalLevel(),c:GetOriginalAttribute())
end
function c249000747.tgfilter2(c,e,tp,lv,att)
	return c:IsType(TYPE_LINK) and c:GetLink()<=math.ceil(lv/2) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function c249000747.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000747.tgfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000747.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c249000747.tgfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc then
		local sc=Duel.SelectMatchingCard(tp,c249000747.tgfilter2,tp,LOCATION_EXTRA,0,1,1,tc,e,tp,tc:GetOriginalLevel(),tc:GetOriginalAttribute()):GetFirst()
		if sc then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
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
				e2:SetRange(LOCATION_MZONE)
				e2:SetCountLimit(1)
				e2:SetCondition(c249000747.retcon)
				e2:SetOperation(c249000747.retop)
				sc:RegisterEffect(e2)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function c249000747.retcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c249000747.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
end