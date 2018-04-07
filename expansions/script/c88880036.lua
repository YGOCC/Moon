--Universal-Eyes Divine Lord Mirrorwing Dragon
function c88880036.initial_effect(c)
	--(1)Enable Revive Limit
	c:EnableReviveLimit()
	--(2)Destroy all monsters
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c88880036.destg)
	e1:SetOperation(c88880036.desop)
	c:RegisterEffect(e1)
	--(3)des 1 monster
	--local e2=Effect.CreateEffect(c)
	--e2:SetDescription(aux.Stringid(27,1))
	--e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SUMMON)
	--e2:SetType(EFFECT_TYPE_FIELD)
	--e2:SetRange(LOCATION_MZONE)
	--e2:SetCode(EVENT_SUMMON_SUCCESS)
	--e2:SetCondition(c88880036.desscon)
	--e2:SetTarget(c88880036.desstar)
	--e2:SetOperation(c88880036.dessop)
	--c:RegisterEffect(e2)
	--(4) Des all monsters when attacked
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_CONFIRM)
	e3:SetCondition(c88880036.dessscon)
	e3:SetTarget(c88880036.destg)
	e3:SetOperation(c88880036.desop)
	c:RegisterEffect(e3)
end
--(3)des 1 monster

--(4)des all monsters when attacked
function c88880036.dessscon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  e:SetLabelObject(bc)
  return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle()
end
--(2+4) destroy effect
function c88880036.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c88880036.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
