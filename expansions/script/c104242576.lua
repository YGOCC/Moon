--Moon's Dream: Lunar Cycles
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
--	e1:SetCountLimit(1,id)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)

end
--Filters
function cid.lpfilter(c)
	return c:IsSetCard(0x666) 
end
function cid.filter(c)
	return c:IsSetCard(0x666) and c:IsAbleToDeck()
end
function cid.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666) and c:IsAbleToHand() 
end
function cid.fragment(c)
return c:IsCode(104242585) and c:IsFaceup()
end
--effect 1
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
	if	Duel.IsExistingMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(cid.lpfilter,tp,LOCATION_GRAVE,0,1,nil) and  Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		local frag=Duel.GetFirstMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,nil,e,tp)
		if frag and Duel.RemoveCards then
		Duel.RemoveCards(frag,nil,REASON_EFFECT+REASON_RULE) 
			Duel.Remove(frag,POS_FACEUP,REASON_EFFECT) 
	end
		if frag and not Duel.RemoveCards then 
		Duel.Exile(frag,REASON_EFFECT+REASON_RULE)
	
	end
			Duel.SetTargetPlayer(tp)
			local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
			local dam=Duel.GetMatchingGroupCount(cid.lpfilter,tp,LOCATION_GRAVE,0,nil)*500
			Duel.Recover(p,dam,REASON_EFFECT)
		end
	end
end

function cid.fragcon(e,tp,eg,ep,ev,re,r,rp)
	return  tp==Duel.GetTurnPlayer() and Duel.GetTurnCount()~=e:GetHandler():GetTurnID() or e:GetHandler():IsReason(REASON_RETURN)
end
function cid.fragtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function cid.fragop(e,tp,eg,ep,ev,re,r,rp,chk)		
	--	local sc=Duel.CreateToken(tp,104242585)
	--	sc:SetCardData(CARDDATA_TYPE,sc:GetType()-TYPE_TOKEN)
	--	Duel.SendtoExtraP(sc,tp,REASON_RULE)
	    local c=e:GetHandler()
		if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 then
		local sc=Duel.CreateToken(tp,104242585)
		sc:SetCardData(CARDDATA_TYPE,sc:GetType()-TYPE_TOKEN)
		Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
end
end
