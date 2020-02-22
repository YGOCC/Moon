--Heavenly Scales of the Skydians
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
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cid.immtg)
	e2:SetValue(cid.efilter)
	c:RegisterEffect(e2)
end
--Activate
--filters
function cid.filter(c)
	return c:IsSetCard(0x223) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
---------
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--IMMUNE
function cid.immtg(e,c)
	if not c:IsSetCard(0x223) or c:GetSummonLocation()~=LOCATION_EXTRA then return false end
	local typelist,check={TYPE_RITUAL,TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_PENDULUM,TYPE_LINK},false
	local sg=Duel.GetMatchingGroup(cid.rmfilter,c:GetControler(),LOCATION_REMOVED,0,nil)
	for ct=1,#typelist do
		if sg:IsExists(Card.IsType,1,nil,typelist[ct]) and c:IsType(typelist[ct]) then
			check=true
			break
		end
	end
	return check
end
function cid.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end