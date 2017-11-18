--Bushido God Leviathan
function c1020051.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c1020051.ffilter,3,false)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c1020051.unval)
	c:RegisterEffect(e1)
	--return
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(29343734,0))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c1020051.retcon)
	e4:SetCost(c1020051.retcost)
	e4:SetTarget(c1020051.rettg)
	e4:SetOperation(c1020051.retop)
	c:RegisterEffect(e4)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(3966653,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c1020051.spcost)
	e3:SetTarget(c1020051.sptg)
	e3:SetOperation(c1020051.spop)
	c:RegisterEffect(e3)
end
--function c1020051.ffilter(c)
--	return c:IsLevelAbove(4) and c:IsFusionSetCard(0x4b0)
--end
function c1020051.unval(e,re)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsControler(1-e:GetHandlerPlayer()) and re:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
		and re:GetHandler():IsLocation(LOCATION_MZONE)
end
function c1020051.ffilter(c,fc,sumtype,tp)
-return c:IsLevelAbove(4) and c:IsFusionSetCard(0x4b0)
end
function c1020051.contactfil(tp)
	return Duel.GetReleaseGroup(tp)
end
function c1020051.contactop(g)
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
end
function c1020051.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c1020051.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4b0) and c:IsType(TYPE_MONSTER)
end
function c1020051.retcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c1020051.cfilter,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return g:FilterCount(Card.IsAbleToDeckOrExtraAsCost,nil)==g:GetCount() end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c1020051.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local label=e:GetLabel()
	e:SetLabel(0)
	Duel.SetTargetParam(label*300)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,label*300)
end
function c1020051.retop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Recover(tp,lp,REASON_EFFECT)
	Duel.Recover(1-tp,lp,REASON_EFFECT)
end
function c1020051.spfilter(c)
	return c:IsSetCard(0x4b0) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c1020051.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1020051.spfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1020051.spfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c1020051.filter(c,e,tp)
	return c:IsSetCard(0x4b0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c1020051.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1020051.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c1020051.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c1020051.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end
