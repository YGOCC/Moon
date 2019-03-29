--SKILL: Pescata Doppia
--Script by XGlitchy30 & Stormbreaker
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--ED Skill Properties
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(cid.skillcon)
	e1:SetValue(cid.efilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(0)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_USE_AS_COST)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--Double Draw
	local SKILL=Effect.CreateEffect(c)
	SKILL:SetCategory(CATEGORY_DRAW)
	SKILL:SetType(EFFECT_TYPE_IGNITION)
	SKILL:SetRange(LOCATION_EXTRA)
	SKILL:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_PLAYER_TARGET)
	SKILL:SetCost(cid.skillcon_skill)
	SKILL:SetOperation(cid.skillop)
	c:RegisterEffect(SKILL)
end
--filters
function cid.skillcon(e)
	return e:GetHandler():IsFaceup() and e:GetHandler():GetFlagEffect(99988871)>0
end
function cid.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
--Double Draw
function cid.skillcon_skill(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.Exile(e:GetHandler(),REASON_COST)
end
function cid.skillop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetTargetRange(1,0)
	e1:SetValue(2)
	Duel.RegisterEffect(e1,tp)
end