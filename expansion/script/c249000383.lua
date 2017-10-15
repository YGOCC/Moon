--Elven Mage Paladin - Ruby
function c249000383.initial_effect(c)
	if not c249000383.global_check then
		c249000383.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_OVERLAY,LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,249000383))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
	--summon xyz
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c249000383.condition)
	e3:SetCost(c249000383.cost)
	e3:SetTarget(c249000383.target)
	e3:SetOperation(c249000383.operation)
	c:RegisterEffect(e3)
end
function c249000383.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c249000383.rmfilter(c)
	return c:IsSetCard(0x1B7) and c:IsAbleToRemoveAsCost() and ((not c:IsLocation(LOCATION_EXTRA)) or (c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)))
end
function c249000383.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000383.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	local sg=Duel.SelectMatchingCard(tp,c249000383.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c249000383.spfilter(c,e,tp,lv,race)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetRank()==lv and c:IsType(TYPE_XYZ) and c:IsRace(race)
end
function c249000383.rmfilter2(c,e,tp)
	return c:IsLevelAbove(1) and c:IsAbleToRemove()
	and Duel.IsExistingMatchingCard(c249000383.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel(),c:GetRace())
end
function c249000383.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000383.rmfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
end
function c249000383.overlayfilter(c)
	return (not c:IsHasEffect(EFFECT_NECRO_VALLEY)) and (not c:IsType(TYPE_MONSTER))
end
function c249000383.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c249000383.rmfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) then return end
	local cg=Duel.SelectMatchingCard(tp,c249000383.rmfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local cc=cg:GetFirst()
	if Duel.Remove(cc,POS_FACEUP,REASON_EFFECT)~=1 then return end
	if not Duel.IsExistingMatchingCard(c249000383.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,cc:GetLevel(),cc:GetRace()) then return end
	local g=Duel.SelectMatchingCard(tp,c249000383.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,cc:GetLevel(),cc:GetRace())
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		if c:IsRelateToEffect(e) then
			Duel.Overlay(tc,Group.FromCards(c))
		end
		if Duel.IsExistingMatchingCard(c249000383.overlayfilter,tp,LOCATION_GRAVE,0,1,nil) then
			local g=Duel.SelectMatchingCard(tp,c249000383.overlayfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.Overlay(tc,g)
			end
		end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetOperation(c249000383.retop)
		tc:RegisterEffect(e2)	
	end
end
function c249000383.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
end