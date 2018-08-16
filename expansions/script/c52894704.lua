--Root's Von Bon
--Keddy was here~
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
	aux.AddFusionProcCodeFun(c,52894703,cod.ffilter,1,true,false)
	--Sp Summon Con
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(cod.negcon)
    e2:SetTarget(cod.negtg)
    e2:SetOperation(cod.negop)
    c:RegisterEffect(e2)
    --BGM Music
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetOperation(cod.bgmop)
    c:RegisterEffect(e3)
    --Turn Reg
	if not cod.global_check then
		cod.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(cod.sumreg)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge3,0)
	end
end

--Fusion Filter
function cod.ffilter(c)
	if not c:GetFlagEffectLabel(id) then return false end
	local turn=c:GetFlagEffectLabel(id)
	return Duel.GetTurnCount()>=turn+2
end

--Turn Reg
function cod.fcfilter(c,tp)
	return c:IsControler(tp) and c:IsFaceup()
end
function cod.sumreg(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cod.fcfilter,nil,tp)
	for tc in aux.Next(g) do
		local tid=Duel.GetTurnCount()
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,tid)
	end
end

--Negate
function cod.negcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cod.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function cod.negop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.NegateEffect(ev) then return end
    if re:GetHandler():IsRelateToEffect(re) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
    	Duel.Destroy(eg,REASON_EFFECT)
    else
    	Duel.BreakEffect()
    	if Duel.GetCurrentPhase()>=8 and Duel.GetCurrentPhase()<=80 then
        	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
        else
        	Duel.SkipPhase(Duel.GetTurnPlayer(),Duel.GetCurrentPhase(),RESET_PHASE+PHASE_END,1)
        end
    end
end

--BGM Music
function cod.bgmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(11,0,aux.Stringid(id,2))
end