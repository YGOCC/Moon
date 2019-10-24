--Divine Relic Zooracle
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
	c:SetSPSummonOnce(id)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_BEAST+RACE_BEASTWARRIOR),2,2)
	--extra normal summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cid.sumcon)
	e1:SetOperation(cid.sumsuc)
	c:RegisterEffect(e1)
	--protection
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e2x=e2:Clone()
	e2x:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2x:SetValue(cid.indval)
	c:RegisterEffect(e2x)
	local e2y=e2:Clone()
	e2y:SetType(EFFECT_TYPE_FIELD)
	e2y:SetProperty(0)
	e2y:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2y:SetTarget(cid.indtg)
	c:RegisterEffect(e2y)
	local e2z=e2x:Clone()
	e2z:SetType(EFFECT_TYPE_FIELD)
	e2z:SetProperty(0)
	e2z:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2z:SetTarget(cid.indtg)
	c:RegisterEffect(e2z)
	--gain atk
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cid.atkcon)
	e3:SetOperation(cid.atkop)
	c:RegisterEffect(e3)
end
--EXTRA NORMAL SUMMON
function cid.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cid.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local ct,ok=1,1
	local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_SET_SUMMON_COUNT_LIMIT)}
	for _,te in ipairs(ce) do
		ok=0
		ct=math.max(ct,te:GetValue())+1
	end
	if ok==1 then ct=2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(ct)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cid.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cid.splimit(e,c)
	return not c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR)
end
--PROTECTION
function cid.indval(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function cid.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
--GAIN ATK
function cid.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local des=eg:GetFirst()
	if not des:IsReason(REASON_BATTLE) or des:GetPreviousControler()==tp then return false end
	local rc=des:GetReasonCard()
	return rc and rc:IsRelateToBattle() and e:GetHandler():GetLinkedGroup():IsContains(rc)
end
function cid.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() then return end
	Duel.Hint(HINT_CARD,tp,id)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end