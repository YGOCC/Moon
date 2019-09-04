--Stellallineamento del Millennio
--Scripted by: XGlitchy30
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCondition(cid.condition)
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
	--lock chain
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+100)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(cid.lcop)
	c:RegisterEffect(e2)
end
--ACTIVATE
--filters
function cid.costfilter(c,e,tp)
	return c:IsSetCard(0x2595) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(cid.spfilter,tp,LOCATION_DECK,0,1,c,c:GetCode(),e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsAbleToGraveAsCost()
end
function cid.spfilter(c,code,e,tp)
	return c:IsSetCard(0x2595) and c:IsType(TYPE_MONSTER) and c:IsCode(code)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
---------
function cid.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_MONSTER)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(cid.costfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cid.costfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g==1 then
		Duel.SendtoGrave(g,REASON_COST)
		Duel.SetTargetCard(g)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.spfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode(),e,tp)
	local tg=g:GetFirst()
	if tg and Duel.SpecialSummonStep(tg,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tg:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
--LOCK CHAIN
function cid.lcop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(cid.actop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cid.actop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0x2595) and ep==tp then
		Duel.SetChainLimit(cid.chainlm)
	end
end
function cid.chainlm(e,rp,tp)
	return tp==rp
end