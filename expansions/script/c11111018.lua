--Esmera, the Skydian's Dark Glory
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
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(cid.thcon)
	e1:SetTarget(cid.thtg)
	e1:SetOperation(cid.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cid.sptg)
	e2:SetOperation(cid.spop)
	c:RegisterEffect(e2)
end
--SEARCH
--filters
function cid.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x223) and c:IsAbleToHand()
end
---------
function cid.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x223)
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--SPECIAL SUMMON
--filters
function cid.exfilter(c,mg)
	if not c:IsType(TYPE_MONSTER) or not c:IsSetCard(0x223) or (c:IsType(TYPE_PENDULUM) and c:IsFaceup()) then return false end
	return c:IsSynchroSummonable(nil,mg) or c:IsXyzSummonable(nil,mg) or c:IsLinkSummonable(nil,mg)
end
---------
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(cid.exfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(cid.exfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if #g>0 then
		local opt,ct=0,0
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil):GetFirst()
		if sg:IsSynchroSummonable(nil,mg) then opt=opt|TYPE_SYNCHRO ct=ct+1 end
		if sg:IsXyzSummonable(nil,mg) then opt=opt|TYPE_XYZ ct=ct+1 end
		if sg:IsLinkSummonable(nil,mg) then opt=opt|TYPE_LINK ct=ct+1 end
		if ct>1 then
			local ok=true
			while ok do
				if opt&TYPE_SYNCHRO>0 then
					if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
						opt=TYPE_SYNCHRO
						ok=false
						break
					end
				end
				if opt&TYPE_XYZ>0 then
					if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
						opt=TYPE_XYZ
						ok=false
						break
					end
				end
				if opt&TYPE_LINK>0 then
					if Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
						opt=TYPE_LINK
						ok=false
						break
					end
				end
			end
		end
		if opt&TYPE_SYNCHRO>0 then
			Duel.SynchroSummon(tp,sg,nil,mg)
		elseif opt&TYPE_XYZ>0 then
			Duel.XyzSummon(tp,sg,nil,mg)
		elseif opt&TYPE_LINK>0 then
			Duel.LinkSummon(tp,sg,nil,mg)
		else
			return
		end
	end
end