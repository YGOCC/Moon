--Fallenblade - Lord
function c543516051.initial_effect(c)
	c:SetUniqueOnField(1,0,543516051)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c543516051.sprcon)
	e1:SetOperation(c543516051.sprop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(543516051,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,543516051)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c543516051.drcost)
	e2:SetTarget(c543516051.drtg)
	e2:SetOperation(c543516051.drop)
	c:RegisterEffect(e2)
	--special from banish
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(543516051,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,543516047)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c543516051.sptg)
	e3:SetOperation(c543516051.spop)
	c:RegisterEffect(e3)
end
function c543516051.spfilter(c)
	return c:IsSetCard(0x21f) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c543516051.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c543516051.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,2,c)
end
function c543516051.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c543516051.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,2,2,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c543516051.costfilter(c)
	return c:IsSetCard(0x21f) and c:IsAbleToRemoveAsCost()
end
function c543516051.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c543516051.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c543516051.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c543516051.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c543516051.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c543516051.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x21f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c543516051.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c543516051.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c543516051.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c543516051.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		 Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end