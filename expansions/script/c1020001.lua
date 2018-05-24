--Codeman: Zero
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
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(s_id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(scard.condition)
	e1:SetTarget(scard.target)
	e1:SetOperation(scard.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(scard.limop)
	c:RegisterEffect(e4)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EVENT_CHAIN_END)
	e0:SetOperation(scard.limop2)
	c:RegisterEffect(e0)
end
function scard.condition(e,tp,eg,ep,ev,re,r,rp)
	if tp==ep or eg:GetCount()~=1 or eg:GetFirst():GetSummonPlayer()==tp then return false end
	if Duel.GetMatchingGroupCount(scard.filter2,tp,LOCATION_MZONE,0,nil)>0 then
		local c=eg:GetFirst()
		local g=Duel.GetMatchingGroup(scard.filter,tp,LOCATION_MZONE,0,nil)
		local tg=g:GetMinGroup(Card.GetAttack)
		return c:GetBaseAttack()>tg:GetFirst():GetAttack()
	end
end
function scard.filter(c)
	return c:IsFaceup()
end
function scard.filter2(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function scard.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(s_id)==0 end
	local tc=eg:GetFirst()
	e:SetLabel(tc:GetAttack())
	local g=Duel.GetMatchingGroup(scard.filter2,tp,LOCATION_MZONE,0,nil)
	local tg=g:GetMinGroup(Card.GetAttack)
	if tg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=tg:Select(tp,1,1,nil)
		local tg=sg:GetFirst()
		Duel.SetTargetCard(tg)
	else Duel.SetTargetCard(tg)
	end
	Duel.SetTargetCard(eg)
	e:SetLabelObject(tg:GetFirst())
end
function scard.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local lc=tg:GetFirst()
	if lc==tc then lc=tg:GetNext() end
	local ta=tc:GetAttack()
	local c=e:GetHandler()
	if Duel.Release(tc,REASON_EFFECT)>0 then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and eg and ta then
			local atk=eg:GetFirst():GetAttack()
			local chg=atk-ta
			if chg<0 then chg=0 end
			--atk
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(chg)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e1)
			c:RegisterFlagEffect(s_id,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function scard.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(scard.chlimit)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(s_id+100,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function scard.chlimit(e,rp,tp)
	if e:GetHandler():GetFlagEffect(s_id)==0 then return end
	return rp==tp
end
function scard.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(s_id+100)~=0 then
		Duel.SetChainLimitTillChainEnd(scard.chlimit)
	end
	e:GetHandler():ResetFlagEffect(s_id+100)
end
