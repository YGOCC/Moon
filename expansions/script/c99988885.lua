--SKILL: Scoppio Ritardato
--Script by XGlitchy30
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	aux.AddOrigSkillType(c)
	--ED Skill Properties
	aux.EDSkillProperties(c)
	--Afterblow
	local SKILL=Effect.CreateEffect(c)
	SKILL:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	SKILL:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	SKILL:SetRange(LOCATION_EXTRA)
	SKILL:SetCode(EVENT_DESTROYED)
	SKILL:SetCondition(cid.skillcon_skill)
	SKILL:SetOperation(cid.skillop)
	c:RegisterEffect(SKILL)
end
--filters
function cid.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==1-tp
		and c:GetReasonCard():IsControler(tp)
end
--Afterblow
function cid.skillcon_skill(e,tp,eg,ep,ev,re,r,rp)
	return aux.skillcon(e) and eg:IsExists(cid.cfilter,1,nil,tp)
end
function cid.skillop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,1-tp,id)
	Duel.Damage(1-tp,700,REASON_RULE)
end