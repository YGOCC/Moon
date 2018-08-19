--Corrupted World Tree
--Keddy was here~
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
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cod.activate)
	c:RegisterEffect(e1)
	--Move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCost(cod.mvcost)
	e2:SetTarget(cod.mvtg)
	e2:SetOperation(cod.mvop)
	c:RegisterEffect(e2)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(cod.thcost)
	e3:SetTarget(cod.thtg)
	e3:SetOperation(cod.thop)
	c:RegisterEffect(e3)
end

--Activate
function cod.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(id,4))
end

--Move
function cod.costfilter(c)
	return c:GetSequence()<5
end
function cod.mvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cod.costfilter,1,nil) and Duel.GetFlagEffect(tp,id)==0 end
	local g=Duel.SelectReleaseGroup(tp,cod.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function cod.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf07a) and c:GetSequence()>=5 and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0
end
function cod.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) and cod.mfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(cod.mfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function cod.mvop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local tc=Duel.SelectMatchingCard(tp,cod.mfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	if not tc or Duel.GetLocationCount(tp,LOCATION_MZONE,ttp,LOCATION_REASON_CONTROL)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local seq=math.log(Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0),2)
	Duel.MoveSequence(tc,seq)
end

--Search
function cod.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() and Duel.GetFlagEffect(tp,id)==0 end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cod.th_filter(c)
	return c:IsAbleToHand() and (c:IsCode(52894708) or c:IsCode(52894710))
end
function cod.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and cod.th_filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(cod.th_filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function cod.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cod.th_filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g<=0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end