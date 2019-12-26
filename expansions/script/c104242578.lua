--Moon's Dream: Fight Back!
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
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(cid.condition)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(cid.condition2)
	c:RegisterEffect(e2)
end
--Filters
function cid.exxxfilter(c)
	return c:IsSetCard(0x666) and c:IsDiscardable()
end
function cid.filter(c,p)
	return (c:IsOnField() and c:IsFaceup() and c:IsSetCard(0x666)) or (c:IsOnField() and c:IsFacedown())
end
function cid.spfilter(c,e,tp)
	return c:IsSetCard(0x666) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end
--Gy effect
function cid.exxxcon(e,tp,eg,ep,ev,re,r,rp)
	   return (bit.band(r,REASON_EFFECT)~=0 or bit.band(r,REASON_COST)~=0) and re:GetHandler():IsSetCard(0x666) and re:GetLabel()~=999
end
function cid.exxxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return  chkc:IsLocation(LOCATION_HAND) and cid.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cid.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cid.exxxop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
		local sc=Duel.CreateToken(tp,104242585)
		sc:SetCardData(CARDDATA_TYPE,sc:GetType()-TYPE_TOKEN)
		Duel.Remove(sc,POS_FACEUP,REASON_RULE)
--		sc:SetCardData(CARDDATA_TYPE, sc:GetType()+TYPE_SPELL)
--		Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function cid.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(cid.filter,nil,tp)-tg:GetCount()>0
end
function cid.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	return ex and tg~=nil and tc+tg:FilterCount(cid.filter,nil,tp)-tg:GetCount()>0
end
function cid.sfilter(c,e,tp)
	return c:IsSetCard(0x666) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsDisabled() then
		if Duel.NegateEffect(ev) and tc:IsRelateToEffect(re) then Duel.Destroy(eg,REASON_EFFECT)
		end
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
		Duel.ConfirmCards(1-tp,c)
	end
	end
	end
end