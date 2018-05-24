--Oven Hijinks
local ref=_G['c'..28916029]
local id=28916029
function ref.initial_effect(c)
	c:EnableCounterPermit(1847)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Draw+Discard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(ref.drtg)
	e1:SetOperation(ref.drop)
	c:RegisterEffect(e1)
	--Place Counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(ref.acop)
	c:RegisterEffect(e2)
	--Apply Effects
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,5))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id)
	e3:SetCost(ref.effcost)
	e3:SetTarget(ref.efftg)
	e3:SetOperation(ref.effop)
	c:RegisterEffect(e3)
end

--Draw+Discard
function ref.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,0)
end
function ref.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		end
	end
end

--Place Counter
function ref.cfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsFaceup()
end
function ref.acop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(ref.cfilter,1,nil) then
		e:GetHandler():AddCounter(1847,1)
	end
end

--Apply Effects
function ref.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,1847,2,REASON_COST) end
	c:RemoveCounter(tp,1847,2,REASON_COST)
end
function ref.tgfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToGrave()
end
function ref.thfilter(c)
	return c:IsSetCard(1847) and c:IsAbleToHand()
end
function ref.ssfilter(c,e,tp)
	return c:IsRace(RACE_FAIRY) and c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,0,tp,tp,false,false)
end
function ref.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.tgfilter,tp,LOCATION_DECK,0,1,nil)
		or Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
		or Duel.IsExistingMatchingCard(ref.thfilter,tp,LOCATION_REMOVED,0,1,nil)
		or Duel.IsExistingMatchingCard(ref.ssfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		--[[local opts=0
		if Duel.IsExistingMatchingCard(ref.tgfilter,tp,LOCATION_DECK,0,1,nil) then opts=opts+1 end
		if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) then opts=opts+1 end
		if Duel.IsExistingMatchingCard(ref.thfilter,tp,LOCATION_REMOVED,0,1,nil) then opts=opts+1 end
		if Duel.IsExistingMatchingCard(ref.ssfilter,tp,LOCATION_HAND,0,1,nil,e,tp) then opts=opts+1 end
		return opts>1]]
	end
end
function ref.effop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local opts=2
	
	if opts>0 and Duel.IsExistingMatchingCard(ref.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,ref.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
			opts=opts-1
		end
	end
	if opts>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			opts=opts-1
		end
	end
	if opts>0 and Duel.IsExistingMatchingCard(ref.thfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,ref.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			opts=opts-1
		end
	end
	if opts>0 and Duel.IsExistingMatchingCard(ref.ssfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,ref.ssfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			opts=opts-1
		end
	end
end
