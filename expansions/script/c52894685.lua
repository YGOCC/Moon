--Onigami Onry-Oh
--Scripted by Kedy
--Concept by XStutzX
--v1.1
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
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xf05a),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_WIND),true)
	--Sp Summon Con
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cod.fuslimit)
	c:RegisterEffect(e0)
	--Flip face-down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
	e1:SetCondition(function (e,tp,eg,ep,ev,re,r,rp) return not eg:IsContains(e:GetHandler()) end)
	e1:SetCost(cod.fdcost)
	e1:SetTarget(cod.fdtg)
	e1:SetOperation(cod.fdop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cod.fdcon2)
	e2:SetCost(cod.fdcost)
	e2:SetTarget(cod.fdtg)
	e2:SetOperation(cod.fdop)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetCondition(cod.descon)
	e3:SetOperation(cod.desop)
	c:RegisterEffect(e3)
end

--Fustion Limit
function cod.fuslimit(e,se,sp,st)
	return st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION and se:GetHandler():IsSetCard(0xf05a)
end

--Flip FD
function cod.cfilter(c)
	return c:IsSetCard(0xf05b) 
end
function cod.fdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cod.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,cod.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
end
function cod.pfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cod.fdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cod.pfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,tp,LOCATION_MZONE)
end
function cod.fdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,cod.pfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if #g<=0 then return end
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE,0,POS_FACEDOWN_DEFENSE,0)
end

--Flip FD 2
function cod.fdcon2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end

--Destroy
function cod.descon(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=a:GetBattleTarget()
	if a:IsControler(1-tp) then 
		e:SetLabelObject(a)
		return d and d==e:GetHandler() and a:IsFacedown() 
	end
	if a==e:GetHandler() then 
		e:SetLabelObject(d)
		return d and d:IsFacedown()
	end
end
function cod.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() and tc:IsFacedown() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end