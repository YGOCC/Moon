--Unnamed thing
--Automate ID
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()

function scard.initial_effect(c)
	c:SetUniqueOnField(1,0,s_id)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(scard.drawop)
	c:RegisterEffect(e1)
	if not scard.global_check then
		scard.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(scard.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function scard.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,30000)==0 then 
		Duel.CreateToken(tp,30000)
		Duel.CreateToken(1-tp,30000)
		Duel.RegisterFlagEffect(0,30000,0,0,0)
	end
end
function scard.drawop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(scard.drawfilter,1,nil,tp) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetRange(LOCATION_SZONE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
		e1:SetOperation(scard.drawdrawop)
		e:GetHandler():RegisterEffect(e1,true)
		e1:SetLabel(bit.lshift(Duel.GetCurrentChain(),16)+eg:FilterCount(scard.drawfilter,nil,tp))
	end
end
function scard.drawdrawop(e,tp)
	if Duel.GetCurrentChain()==bit.rshift(e:GetLabel(),16) then
		local n=bit.band(e:GetLabel(),0xffff)
		local m=Duel.DiscardHand(1-tp,Card.IsDiscardable,n,n,REASON_EFFECT+REASON_DISCARD,nil,REASON_EFFECT)
		if n>m then
			Duel.Draw(tp,n-m,REASON_EFFECT)
		end
	end
end
function scard.drawfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and c:GetPreviousControler()==tp and c:IsType(TYPE_MONSTER) and c:IsMantra()
		and (c:GetReason()==REASON_COST and c:GetReason()==REASON_EFFECT)~=0
end
