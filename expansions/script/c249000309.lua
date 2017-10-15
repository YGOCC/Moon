--Magical Forces Arts - Flash Summon
function c249000309.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c249000309.condition)
	e1:SetTarget(c249000309.target)
	e1:SetOperation(c249000309.activate)
	c:RegisterEffect(e1)
end
function c249000309.confilter(c)
	return c:IsSetCard(0x15A) and c:IsType(TYPE_MONSTER)  and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVEYARD))
end
function c249000309.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
	and Duel.IsExistingMatchingCard(c249000309.confilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function c249000309.filter(c,e,tp)
	return c:IsSetCard(0x15A) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c249000309.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000309.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetTargetCard(re:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c249000309.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.SelectMatchingCard(tp,c249000309.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
