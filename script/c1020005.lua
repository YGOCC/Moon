--Codeman Interference
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
	--Recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(s_id,2))
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCondition(scard.con)
	e4:SetOperation(scard.op)
	e4:SetCountLimit(1,s_id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e4)
end
function scard.recfilter(c)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsSetCard(0xded) and c:IsType(TYPE_MONSTER)
end
function scard.spfilter(c,e,tp)
	return c:IsSetCard(0xded) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function scard.con(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(scard.recfilter,nil)
	return g:GetCount()>0 and Duel.IsExistingMatchingCard(scard.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function scard.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,scard.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 then
		local c=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		c:RegisterEffect(e2)
	end
end
