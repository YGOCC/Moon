--Hawk
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
	--synchro summon
	aux.AddSynchroProcedure(c,nil,scard.syn,1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,s_id+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(scard.con)
	e1:SetTarget(scard.tg)
	e1:SetOperation(scard.op)
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
function scard.syn(c)
	return aux.NonTuner(Card.IsMantra)
end
function scard.con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function scard.filter(c)
	return c:IsMantra() and c:IsType(TYPE_MONSTER) and not c:IsCode(s_id)
end
function scard.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(scard.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD)
end
function scard.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(scard.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,nil)
	local g=0
	if rg:GetCount()>0 then 
        local tg=Group.CreateGroup()
        local i=3
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local tc=rg:Select(tp,1,1,nil):GetFirst()
        rg:Remove(Card.IsCode,nil,tc:GetCode())
        tg:AddCard(tc)
        i=i-1
		g=g+1
		if Duel.SelectYesNo(tp,aux.Stringid(s_id,0)) then
			repeat
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tc=rg:Select(tp,1,1,nil):GetFirst()
			rg:Remove(Card.IsCode,nil,tc:GetCode())
			tg:AddCard(tc)
			i=i-1
			g=g+1
			until i<1 or rg:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(s_id,0))
		end
        Duel.SendtoGrave(tg,REASON_EFFECT)
    end
	if g>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(g*600)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
