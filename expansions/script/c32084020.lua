--Orichalcos Altar
function c32084020.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--tribute summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(32084020,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c32084020.condition)
	e3:SetTarget(c32084020.sumtg)
	e3:SetOperation(c32084020.sumop)
	c:RegisterEffect(e3)
end
function c32084020.cfilter(c)
	return c:IsFaceup() and c:IsCode(48179391)
end
function c32084020.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c32084020.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c32084020.sumfilter(c)
	return c:IsLevelAbove(5)
end
function c32084020.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32084020.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c32084020.sumop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c32084020.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil,1)
	end
end