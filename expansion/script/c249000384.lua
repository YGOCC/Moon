--Elven Mage Paladin - Sapphira
function c249000384.initial_effect(c)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(249000338,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdcon)
	e2:SetTarget(c249000384.destg)
	e2:SetOperation(c249000384.desop)
	c:RegisterEffect(e2)
	--summon synchro
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c249000384.condition)
	e3:SetCost(c249000384.cost)
	e3:SetTarget(c249000384.target)
	e3:SetOperation(c249000384.operation)
	c:RegisterEffect(e3)
end
function c249000384.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c249000384.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c249000384.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c249000384.rmfilter(c)
	return c:IsSetCard(0x1B7) and c:IsAbleToRemoveAsCost() and ((not c:IsLocation(LOCATION_EXTRA)) or (c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)))
end
function c249000384.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
	and Duel.IsExistingMatchingCard(c249000384.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	local sg=Duel.SelectMatchingCard(tp,c249000384.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c249000384.spfilter(c,e,tp,lv,race)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()==lv and c:IsType(TYPE_SYNCHRO) and c:GetRace()==race
end
function c249000384.rmfilter2(c,e,tp)
	return c:IsLevelAbove(1) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c249000384.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel(),c:GetRace())
end
function c249000384.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000384.rmfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
end
function c249000384.operation(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.SelectMatchingCard(tp,c249000384.rmfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local cc=cg:GetFirst()
	if Duel.Remove(cc,POS_FACEUP,REASON_EFFECT)~=1 then return end
	if not Duel.IsExistingMatchingCard(c249000384.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,cc:GetLevel(),cc:GetRace()) then return end
	local g=Duel.SelectMatchingCard(tp,c249000384.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,cc:GetLevel(),cc:GetRace())
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetOperation(c249000384.retop)
		tc:RegisterEffect(e2)	
	end
end
function c249000384.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
end