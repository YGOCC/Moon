--Pyro Spel Burst
function c249000455.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c249000455.cost)
	e1:SetTarget(c249000455.target)
	e1:SetOperation(c249000455.activate)
	c:RegisterEffect(e1)
end
function c249000455.cfilter(c,code)
	return c:IsCode(code) and c:IsAbleToDeckAsCost()
end
function c249000455.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000455.cfilter,tp,LOCATION_GRAVE,0,1,nil,249000451)
		and Duel.IsExistingMatchingCard(c249000455.cfilter,tp,LOCATION_GRAVE,0,1,nil,249000452)
		and Duel.IsExistingMatchingCard(c249000455.cfilter,tp,LOCATION_GRAVE,0,1,nil,249000453)
		and Duel.IsExistingMatchingCard(c249000455.cfilter,tp,LOCATION_GRAVE,0,1,nil,249000454) end
	local tc1=Duel.GetFirstMatchingCard(c249000455.cfilter,tp,LOCATION_GRAVE,0,nil,249000451)
	local tc2=Duel.GetFirstMatchingCard(c249000455.cfilter,tp,LOCATION_GRAVE,0,nil,249000452)
	local tc3=Duel.GetFirstMatchingCard(c249000455.cfilter,tp,LOCATION_GRAVE,0,nil,249000453)
	local tc4=Duel.GetFirstMatchingCard(c249000455.cfilter,tp,LOCATION_GRAVE,0,nil,249000454)
	local g=Group.FromCards(tc1,tc2,tc3,tc4)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c249000455.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c249000455.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000455.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND)
end
function c249000455.damagefilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:GetLevel() > 0 and c:IsFaceup()
end
function c249000455.desctfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsFaceup()
end
function c249000455.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c249000455.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
		local g2=Duel.GetMatchingGroup(c249000455.damagefilter,tp,LOCATION_MZONE,0,nil)
		if g2:GetCount() > 0 then	
			local damageval=g2:GetSum(Card.GetLevel)*100
			Duel.Damage(1-tp,damageval,REASON_EFFECT)
		end
		local ct=Duel.GetMatchingGroupCount(c249000455.desctfilter,tp,LOCATION_MZONE,0,nil)
		if ct > 0 and Duel.SelectYesNo(tp,aux.Stringid(16037007,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,ct,nil,e,tp)
			Duel.Destroy(sg,REASON_EFFECT)
		end		
	end
end
