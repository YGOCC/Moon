--created by ZEN, coded by TaxingCorn117
--Blood Arts Commander - Erse
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cid.sumcon)
	c:RegisterEffect(e1)
	if cid.counter==nil then
		cid.counter=true
		cid[0]=0
		cid[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(cid.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_TOSS_DICE_NEGATE)
		e3:SetOperation(cid.addcount)
		Duel.RegisterEffect(e3,0)
	end
end
function cid.resetcount(e,tp,eg,ep,ev,re,r,rp)
	cid[0]=0
	cid[1]=0
end
function cid.addcount(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	local ci=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
	if cid[2]~=ci then
		local dc={Duel.GetDiceResult()}
		for _,ct in ipairs(dc) do Debug.Message(ct) cid[ep]=cid[ep]+ct end
		Duel.SetDiceResult(table.unpack(dc))
		cid[2]=ci
	end
end
function cid.sumcon(e,c)
	if c==nil then return true end
	return cid[c:GetControler()]>4
end
