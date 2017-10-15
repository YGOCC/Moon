--Empire Royal Guard
function c90000079.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c90000079.condition)
	e1:SetTarget(c90000079.target)
	e1:SetOperation(c90000079.operation)
	c:RegisterEffect(e1)
end
function c90000079.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetAttackTarget()==nil
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c90000079.filter1(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToRemoveAsCost() and c:IsLevelAbove(1)
		and Duel.IsExistingTarget(c90000079.filter2,tp,LOCATION_DECK,0,1,c,e,tp,c:GetLevel())
end
function c90000079.filter2(c,e,tp,lv)
	return c:GetLevel()==lv and c:IsSetCard(0x2d) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function c90000079.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c90000079.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c90000079.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local lv=g:GetFirst():GetLevel()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c90000079.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c90000079.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,true,POS_FACEUP)
		local gc=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local tc=gc:GetFirst()
		while tc do
			tc:AddCounter(0x1000,1)
			tc=gc:GetNext()
		end
	end
end