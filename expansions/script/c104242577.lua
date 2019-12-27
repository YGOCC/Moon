--Moon's Dream, Come Forth!
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
		--Gy effect
	local exxx=Effect.CreateEffect(c)
	exxx:SetDescription(aux.Stringid(33731070,0))
	exxx:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	exxx:SetCode(EVENT_TO_GRAVE)
	exxx:SetProperty(EFFECT_FLAG_DELAY)
	exxx:SetCondition(cid.exxxcon)
	exxx:SetCountLimit(1,id+2000)
	exxx:SetTarget(cid.exxxtg)
	exxx:SetOperation(cid.exxxop)
	c:RegisterEffect(exxx)
	--recursion
	local exx=Effect.CreateEffect(c)
	exx:SetCategory(CATEGORY_TOHAND)
	exx:SetType(EFFECT_TYPE_IGNITION)
	exx:SetRange(LOCATION_GRAVE)
	exx:SetCountLimit(1,id+1000)
	exx:SetCondition(cid.recurcon)
	exx:SetTarget(cid.recurtg)
	exx:SetOperation(cid.recurop)
	c:RegisterEffect(exx)
		--on death search 2
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(cid.condition)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.operation)
	c:RegisterEffect(e1)
end
--Filters
function cid.exxxfilter(c)
	return c:IsSetCard(0x666) and c:IsDiscardable()
end

function cid.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function cid.thfilter(c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cid.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cid.cfilter,1,nil,tp)
end
--Gy effect
function cid.exxxcon(e,tp,eg,ep,ev,re,r,rp)
	   return (bit.band(r,REASON_EFFECT)~=0 or bit.band(r,REASON_COST)~=0) and re:GetHandler():IsSetCard(0x666) and re:GetLabel()~=999
end
function cid.exxxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cid.exxxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,Group.FromCards(c))
	end
		local sc=Duel.CreateToken(tp,104242585)
		sc:SetCardData(CARDDATA_TYPE,sc:GetType()-TYPE_TOKEN)
		Duel.Remove(sc,POS_FACEUP,REASON_RULE)
--		sc:SetCardData(CARDDATA_TYPE, sc:GetType()+TYPE_SPELL)
--		Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.thfilter,tp,LOCATION_DECK,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
		local sc=Duel.CreateToken(tp,104242585)
		sc:SetCardData(CARDDATA_TYPE,sc:GetType()-TYPE_TOKEN)
		Duel.Remove(sc,POS_FACEUP,REASON_RULE)
--		sc:SetCardData(CARDDATA_TYPE, sc:GetType()+TYPE_SPELL)
--		Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)	
end
--recursion
function cid.recurfilter(c)
	return c:IsCode(104242585) and c:IsFaceup()
end
function cid.recurcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(cid.recurfilter,tp,LOCATION_REMOVED,0,3,nil)
end
function cid.recurtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cid.recurop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,cid.recurfilter,tp,LOCATION_REMOVED,0,3,3,nil)
	if g:GetCount()==3 then
	if Duel.Exile(g,REASON_RULE) then
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,Group.FromCards(c))
	end
	end
	end
end