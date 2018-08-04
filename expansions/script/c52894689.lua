--Onigami Beast
--Scripted by Kedy
--Concept by XStutzX
local function ID()
    local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
    str=string.sub(str,1,string.len(str)-4)
    local cod=_G[str]
    local id=tonumber(string.sub(str,2))
    return id,cod
end

local id,cod=ID()
function cod.initial_effect(c)
	--Fusion Summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xf05a),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_EARTH),true)
	--Sp Summon Con
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cod.disop)
	c:RegisterEffect(e1)
	--Flip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_POSCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cod.poscon)
	e3:SetOperation(cod.posop)
	c:RegisterEffect(e3)
end

--Negate
function cod.disop(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if loc~=LOCATION_MZONE or not re:IsHasType(EFFECT_TYPE_SINGLE) then return end
	if re:GetCode()==EVENT_SUMMON_SUCCESS or re:GetCode()==EVENT_SPSUMMON_SUCCESS or re:GetCode()==EVENT_FLIP_SUMMON_SUCCESS then
		Duel.NegateEffect(ev)
	end
end

--Flip FD
function cod.poscon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=a:GetBattleTarget()
	if a:IsControler(1-tp) then 
		e:SetLabelObject(a)
		return d and d:IsSetCard(0xf05b) and a:IsFaceup() 
	end
	if a:IsControler(tp) then 
		e:SetLabelObject(d)
		return d and a:IsSetCard(0xf05b) and d:IsFaceup()
	end
end
function cod.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE,0,POS_FACEDOWN_DEFENSE,0)
	end
end