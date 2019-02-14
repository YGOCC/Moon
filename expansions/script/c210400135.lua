--created & coded by Lyris, art from Chaotic's "Oiponts Claws"
--集いし襲雷
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DRAW)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e0:SetOperation(cid.activate)
	c:RegisterEffect(e0)
	if cid.counter==nil then
		cid.counter=true
		cid[0]=0
		cid[1]=0
		local g=Group.CreateGroup()
		g:KeepAlive()
		cid[2]=g
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(cid.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_DESTROYED)
		e3:SetOperation(cid.addcount)
		Duel.RegisterEffect(e3,0)
	end
end
function cid.resetcount(e,tp,eg,ep,ev,re,r,rp)
	cid[0]=0
	cid[1]=0
	cid[2]:Clear()
end
function cid.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsPreviousLocation(LOCATION_MZONE) and tc:IsPreviousSetCard(0x7c4) then
			local p=tc:GetPreviousControler()
			cid[p]=cid[p]+1
			cid[2]:AddCard(tc)
		elseif tc:IsSetCard(0x7c4) and tc:IsType(TYPE_MONSTER) then
			local p=tc:GetPreviousControler()
			cid[p]=cid[p]+1
			cid[2]:AddCard(tc)
		end
		tc=eg:GetNext()
	end
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(cid.droperation)
	Duel.RegisterEffect(e1,tp)
end
function cid.droperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Draw(tp,cid[2]:GetClassCount(Card.GetCode),REASON_EFFECT)
end
