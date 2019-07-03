--A.O. Regulator
--By Auramram
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
  --search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_END_PHASE)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
--special summon
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
--search
function s.filter(c)
	return c:IsSetCard(0x719)
end
function s.cfilter(c,tp)
	return c:IsReleasable() and Duel.IsPlayerAffectedByEffect(tp,21730412)
end
function s.thfilter(c)
	return c:IsSetCard(0x719) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.CheckReleaseGroup(tp,s.filter,1,false,nil,nil,tp)
	local b2=Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_FZONE,0,1,nil)
	if chk==0 then return c:IsAbleToRemoveAsCost() and (b1 or b2) end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(21730412,2))) then
		local mc=Duel.GetFirstMatchingCard(s.cfilter,tp,LOCATION_FZONE,0,nil)
		Duel.Release(mc,REASON_COST)
	else
		local sg=Duel.SelectReleaseGroup(tp,s.filter,1,1,false,nil,nil,tp)
		Duel.Release(sg,REASON_COST)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
