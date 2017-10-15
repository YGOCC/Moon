--Dark Pitull of Gust Vine
function c160009850.initial_effect(c)
c:EnableReviveLimit()
		c:EnableReviveLimit()
		aux.AddFusionProcFun2(c,c160009850.mfilterx,c160009850.ffilter,true)
		local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(160009850,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,160009850)
	e1:SetCondition(c160009850.condition)
	e1:SetTarget(c160009850.target)
	e1:SetCost(c160009850.cost)
	e1:SetOperation(c160009850.operation)
	c:RegisterEffect(e1)
	
		--spsummon condition
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_SPSUMMON_CONDITION)
	e6:SetValue(c160009850.splimit)
	c:RegisterEffect(e6)

		--deck check
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(160009850,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c160009850.target)
	e2:SetOperation(c160009850.operation)
	c:RegisterEffect(e2)
end

function c160009850.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION+0x786
end
function c160009850.mfilterx(c)
	return c:IsCode(500319541) and not c:IsCode(160009850) and not c:IsLocation(LOCATION_EXTRA)
end
function c160009850.ffilter(c)
	return not c:IsLocation(LOCATION_EXTRA) and (c:GetLevel()>=5 and c:GetCode()~=160009850  or c:IsHasEffect(500317451))
end
function c160009850.tgfilter(c)
	return c:IsSetCard(0x885a) and c:IsAbleToGrave()
end

function c160009850.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c160009850.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c160009850.filter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c160009850.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c160009850.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c160009850.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c160009850.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c160009850.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end

function c160009850.spfilter(c,e,tp)
	return c:IsSetCard(0x885a) and c:IsAbleToGrave()
end
function c160009850.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c160009850.xfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x885a) and c:IsAbleToDeck()
end
function c160009850.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c160009850.rmfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(c160009850.spfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c160009850.spfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,c160009850.rmfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,1,0,0)
end
function c160009850.filter(c)
	return c:IsSetCard(0x885a) and c:IsAbleToGrave()
end
function c160009850.operation(e,tp,eg,ep,ev,re,r,rp)
local ex1,tg1=Duel.GetOperationInfo(0,CATEGORY_TOGRAVE)
	local ex2,tg2=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	if tg1:GetFirst():IsRelateToEffect(e) and tg1:GetFirst():IsSetCard(0x885a) then
	Duel.SendtoGrave(tg1,REASON_EFFECT)
	end
	if tg2:GetFirst():IsRelateToEffect(e) then
		Duel.SendtoDeck(tg2,nil,2,REASON_EFFECT)
	end
end
