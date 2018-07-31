--Des Stone of Horkos
--Scripted by Kedy
--Concept by XStutzX
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
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cod.target)
	e1:SetOperation(cod.activate)
	c:RegisterEffect(e1)
	--Ritual Tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_RITUAL_LEVEL)
	e2:SetValue(cod.rlevel)
	c:RegisterEffect(e2)
	if not cod.global_effect then
		cod.global_effect=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(cod.setcard)
		Duel.RegisterEffect(ge1,0)
	end
end

--Send
function cod.cfilter(c)
	return (c:GetType()&0x82==0x82 or c:GetType()&0x84==0x84) and c:IsAbleToGrave()
end
function cod.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cod.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cod.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cod.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	if #g<=0 then return end
	Duel.SendtoGrave(g,REASON_EFFECT)
end

--Ritual Level
function cod.rlevel(e,c)
	local clv=c:GetLevel()
	return clv
end

--Change in Card Type
function cod.setcard(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) then
		--Only on KoishiPro
		Card.SetCardData(c,5,1)
		Card.SetCardData(c,4,TYPE_MONSTER)
	else
		Card.SetCardData(c,5,0)
		Card.SetCardData(c,4,TYPE_SPELL)
	end
end