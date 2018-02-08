--created & coded by Lyris
--機光襲雷竜－イグニスター
function c240100034.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c240100034.ffilter,2,false)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c240100034.mat)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_DESTROYED)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e0:SetCategory(CATEGORY_DAMAGE)
	e0:SetCountLimit(1,240100386)
	e0:SetLabelObject(e2)
	e0:SetTarget(c240100034.tg)
	e0:SetOperation(c240100034.op)
	c:RegisterEffect(e0)
end
function c240100034.ffilter(c)
	return c:IsRace(RACE_DRAGON) and c:GetBaseAttack()/1000-math.floor(c:GetBaseAttack()/1000)==0
end
function c240100034.mat(e,c)
	local g=c:GetMaterial()
	e:SetLabel(g:GetSum(Card.GetAttack))
end
function c240100034.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	local dam=1000
	if e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) then dam=dam+e:GetLabelObject():GetLabel() end
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c240100034.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
