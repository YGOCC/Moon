--VECTOR Engineer Salvatore
--Scripted by Zerry
function c67864658.initial_effect(c)
--link summon
--	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x22a6),2)
	aux.AddLinkProcedure(c,c67864658.lfilter,2,4)
	c:EnableReviveLimit()
--Special Summon
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67864658,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,67864658)
	e1:SetCondition(c67864658.spcon)
	e1:SetTarget(c67864658.sptg)
	e1:SetOperation(c67864658.spop)
	c:RegisterEffect(e1)
	--negate
local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67864658,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,67864658+100)
	e2:SetCondition(c67864658.negcon)
	e2:SetCost(c67864658.negcost)
	e2:SetTarget(c67864658.negtg)
	e2:SetOperation(c67864658.negop)
	c:RegisterEffect(e2)
end
function c67864658.lfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x62a6)
end
function c67864658.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c67864658.spfilter(c,e,tp)
	return c:IsSetCard(0x62a6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67864658.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67864658.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE)
end
function c67864658.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67864658.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c67864658.cfilter(c,g)
	return g:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c67864658.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c67864658.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckRemoveGroup(tp,c67864658.cfilter,1,nil,lg) end
	local g=Duel.SelectRemoveGroup(tp,c67864658.cfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end
function c67864658.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c67864658.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end