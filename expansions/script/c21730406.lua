--A.O. Tinkerer
function c21730406.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21730406,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c21730406.spcon)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21730406,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_END_PHASE)
	e2:SetCost(c21730406.cost)
	e2:SetTarget(c21730406.target)
	e2:SetOperation(c21730406.operation)
	c:RegisterEffect(e2)
end
--special summon
function c21730406.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
--search
function c21730406.filter(c,tp)
	return c:IsSetCard(0x719)
end
function c21730406.thfilter(c)
	return c:IsSetCard(0x719) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c21730406.rcost(c)
	return c:IsFaceup() and c:IsCode(21730412) and c:IsReleasable() and c:GetFlagEffect(21730412)==0 and not c:IsDisabled() and not c:IsForbidden()
end
function c21730406.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.CheckReleaseGroup(tp,c21730406.filter,1,false,nil,nil,tp)
	local b2=Duel.IsExistingMatchingCard(c21730406.rcost,tp,LOCATION_FZONE,0,1,nil)
	if chk==0 then return c:IsAbleToRemoveAsCost() and (b1 or b2) end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(21730412,2))) then
		local tg=Duel.GetFirstMatchingCard(c21730406.rcost,tp,LOCATION_FZONE,0,nil)
		Duel.Release(tg,REASON_COST)
	else
		local g=Duel.SelectReleaseGroup(tp,c21730406.filter,1,1,false,nil,nil,tp)
		Duel.Release(g,REASON_COST)
	end
end
function c21730406.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c21730406.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21730406.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21730406.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
