--Empire Royal Guard
function c90000090.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c90000090.condition1)
	e1:SetTarget(c90000090.target1)
	e1:SetOperation(c90000090.operation1)
	c:RegisterEffect(e1)
	--Add Counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c90000090.condition2)
	e2:SetCost(c90000090.cost2)
	e2:SetTarget(c90000090.target2)
	e2:SetOperation(c90000090.operation2)
	c:RegisterEffect(e2)
end
function c90000090.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c90000090.filter1_1(c,e,tp)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c90000090.filter1_2,tp,LOCATION_DECK,0,1,c,e,tp,c:GetLevel())
end
function c90000090.filter1_2(c,e,tp,lv)
	return c:GetLevel()==lv and c:IsSetCard(0x5d) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function c90000090.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c90000090.filter1_1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c90000090.filter1_1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local lv=g:GetFirst():GetLevel()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c90000090.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c90000090.filter1_2,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,true,POS_FACEUP)
		local tc=Duel.GetAttacker()
		tc:AddCounter(0x1000,1)
	end
end
function c90000090.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c90000090.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c90000090.filter2(c)
	return c:IsSetCard(0x5d) and not c:IsPublic()
end
function c90000090.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local hg=Duel.GetMatchingGroup(c90000090.filter2,tp,LOCATION_HAND,0,e:GetHandler())
	local ct=Duel.GetTargetCount(Card.IsCanAddCounter,tp,0,LOCATION_ONFIELD,nil,0x1000,1)
	if chk==0 then return hg:GetCount()>0 and ct>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=hg:Select(tp,1,ct,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,0,LOCATION_ONFIELD,g:GetCount(),g:GetCount(),nil,0x1000,1)
end
function c90000090.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=tg:GetFirst()
	while tc do
		tc:AddCounter(0x1000,1)
		tc=tg:GetNext()
	end
end