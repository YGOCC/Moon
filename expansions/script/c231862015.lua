--created by ZEN, coded by TaxingCorn117
--Blood Arts - Taste of Reclamation
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
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2318620,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cid.lpcon)
	e2:SetTarget(cid.lptg)
	e2:SetOperation(cid.lpop)
	c:RegisterEffect(e2)
	--activate 1 from deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2318620,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(cid.actcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cid.acttg)
	e3:SetOperation(cid.actop)
	c:RegisterEffect(e3)
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
		for _,ct in ipairs(dc) do cid[ep]=cid[ep]+ct end
		Duel.SetDiceResult(table.unpack(dc))
		cid[2]=ci
	end
end
function cid.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return cid[tp]>0
end
function cid.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,id)
end
function cid.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ap=Duel.Recover(tp,cid[tp]*50,REASON_EFFECT)
	local ct=c:GetFlagEffectLabel(id)
	if not ct then
		c:RegisterFlagEffect(id,RESET_PHASE+PHASE_END,0,1,ap)
	else
		c:SetFlagEffectLabel(id,ct+ap)
	end
	if c:GetFlagEffectLabel(id)<1000 then return end
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cid.actcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function cid.actfilter(c,tp)
	return c:IsCode(id) and c:GetActivateEffect():IsActivatable(tp)
end
function cid.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.actfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(2318620,3))
	local g=Duel.SelectMatchingCard(tp,cid.actfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	end
end