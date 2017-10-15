--Paintress Warholee
function c160008746.initial_effect(c)
	   --link summon
	aux.AddLinkProcedure(c,c160008746.matfilter,2)
	c:EnableReviveLimit()

	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c160008746.splimit)
	e1:SetCondition(c160008746.splimcon)
	c:RegisterEffect(e1)
  --cannot release
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
  --special summon
	local e3=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(160008746,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c160008746.cost)
	e3:SetTarget(c160008746.target)
	e3:SetOperation(c160008746.operation)
	c:RegisterEffect(e3)
end

function c160008746.matfilter(c)
	return  c:IsSetCard(0xc50) and c:IsLinkType(TYPE_NORMAL)
end
function c160008746.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c160008746.splimcon(e)
	return not e:GetHandler():IsForbidden()
end

function c160008746.filter(c,e,tp,zone)
	return c:IsLevelBelow(4) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c160008746.cfilter(c)
	return c:IsFaceup() c:IsType(TYPE_PENDULUM) and (not c:IsType(TYPE_EFFECT) or c:IsSetCard(0xc50))and c:IsAbleToRemoveAsCost()
end
function c160008746.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c160008746.cfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c160008746.cfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c160008746.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone()
		return zone~=0 and Duel.IsExistingMatchingCard(c160008746.filter,tp,LOCATION_DECK,0,2,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c160008746.operation(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone()
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c160008746.filter,tp,LOCATION_DECK,0,2,2,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
