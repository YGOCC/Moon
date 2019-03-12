--Broken Oath
--Scripted by Kedy
--Concept by XStutzX
--v2.1 3-12-19
local function ID()
    local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
    str=string.sub(str,1,string.len(str)-4)
    local cod=_G[str]
    local id=tonumber(string.sub(str,2))
    return id,cod
end

local id,cod=ID()
function cod.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cod.cost)
	e1:SetTarget(cod.target)
	e1:SetOperation(cod.activate)
	c:RegisterEffect(e1)
	--Return
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cod.rttg)
	e2:SetOperation(cod.rtop)
	c:RegisterEffect(e2)
end

--Set Face-down
function cod.cfilter(c)
	return (c:IsCode(52894690) or c:IsSetCard(0xf05b)) and c:IsAbleToGrave()
end
function cod.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cod.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cod.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_RELEASE+REASON_COST)
end

function cod.filter(c)
	return c:IsFaceup() 
end
function cod.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 
		and Duel.IsExistingMatchingCard(cod.filter,tp,0,LOCATION_ONFIELD,1,nil) end
end

function cod.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,cod.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end

--Return to Extra
function cod.rfilter(c,tp)
	return (c:IsCode(52894690) or c:IsSetCard(0xf05b)) and c:IsAbleToExtra()
		and Duel.IsExistingMatchingCard(cod.sfilter,tp,0,LOCATION_ONFIELD,1,nil)
end
function cod.sfilter(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function cod.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 
		and Duel.IsExistingMatchingCard(cod.rfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
end
function cod.rtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cod.rfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	if #g>0 then
		Duel.HintSelection(g)
		if Duel.SendtoHand(g,nil,REASON_EFFECT)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local rg=Duel.SelectMatchingCard(tp,cod.sfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #rg<=0 then return end
		Duel.HintSelection(rg)
		Duel.SendtoHand(rg,nil,REASON_EFFECT)
	end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end