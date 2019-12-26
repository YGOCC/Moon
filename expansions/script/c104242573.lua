--Moon's Dream: I'm Still Here!
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
	exxx:SetCategory(CATEGORY_TOHAND)
	exxx:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	exxx:SetCode(EVENT_TO_GRAVE)
	exxx:SetProperty(EFFECT_FLAG_DELAY)
	exxx:SetCountLimit(1,id+2000)
	exxx:SetCondition(cid.exxxcon)
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
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(cid.target)
	c:RegisterEffect(e1)
end
--Filters
function cid.exxxfilter(c)
	return c:IsSetCard(0x666) and c:IsDiscardable()
end
function cid.spfilter(c,e,tp)
    return c:IsSetCard(0x666) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.cfilter2(c)
	return c:IsSetCard(0x666) and c:IsDiscardable()
end
function cid.ponybackfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x666) and c:IsAbleToGrave()
end
--Gy effect
function cid.exxxcon(e,tp,eg,ep,ev,re,r,rp)
	   return (bit.band(r,REASON_EFFECT)~=0 or bit.band(r,REASON_COST)~=0) and re:GetHandler():IsSetCard(0x666) and re:GetLabel()~=999
end
function cid.exxxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cid.exxxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
		local sc=Duel.CreateToken(tp,104242585)
		sc:SetCardData(CARDDATA_TYPE,sc:GetType()-TYPE_TOKEN)
		Duel.Remove(sc,POS_FACEUP,REASON_RULE)
--		sc:SetCardData(CARDDATA_TYPE, sc:GetType()+TYPE_SPELL)
--		Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(cid.cfilter2,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end

function cid.drawop(e,tp,eg,ep,ev,re,r,rp)
--	local g=Duel.SelectMatchingCard(tp,cid.cfilter2,tp,LOCATION_HAND,0,1,1,e:GetHandler())
--	Duel.DiscardHand(g,nil,2,REASON_EFFECT+REASON_DISCARD)
	if Duel.DiscardHand(tp,cid.exxxfilter,1,1,REASON_COST+REASON_DISCARD) then
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)  
		if Duel.IsExistingMatchingCard(cid.ponybackfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and 
		Duel.IsExistingMatchingCard(cid.recurfilter,tp,LOCATION_REMOVED,0,1,nil) and
		Duel.SelectEffectYesNo(tp,e:GetHandler(),nil) then
		local g=Duel.GetFirstMatchingCard(cid.recurfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		--if g:GetCount()==1 then
		if Duel.Exile(g,REASON_RULE)>=0 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cid.ponybackfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)>=0 then
		
		end 
		end
		end
		end
		end
		local sc=Duel.CreateToken(tp,104242585)
		sc:SetCardData(CARDDATA_TYPE,sc:GetType()-TYPE_TOKEN)
		Duel.Remove(sc,POS_FACEUP,REASON_RULE)
--		sc:SetCardData(CARDDATA_TYPE, sc:GetType()+TYPE_SPELL)
--		Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
--Activate
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    local b1=Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(cid.cfilter2,tp,LOCATION_HAND,0,1,e:GetHandler()) 
    local b2=Duel.IsExistingMatchingCard(cid.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
    if chk==0 then return b1 or b2 end
    local op=0
    if b1 and b2 then
        op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
    elseif b1 then
        op=Duel.SelectOption(tp,aux.Stringid(id,0))
    else
        op=Duel.SelectOption(tp,aux.Stringid(id,1))+1
    end
	
	
	
    if op==0 then
        e:SetCategory(CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
      	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
		e:SetOperation(cid.drawop)
		e:SetLabel(999)
    else
        e:SetCategory(CATEGORY_SPECIAL_SUMMON)
        e:SetOperation(cid.spop)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
    end
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cid.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
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