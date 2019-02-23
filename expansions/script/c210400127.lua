--created & coded by Lyris, art by FanDragonBrigitha of DeviantArt
--襲雷竜－スパーク津波
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.OR(aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),aux.FilterBoolFunction(Card.IsSetCard,0x7c4)),2,true)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EVENT_ATTACK_ANNOUNCE)
	e0:SetCondition(cid.descon)
	e0:SetTarget(cid.destg)
	e0:SetOperation(cid.desop)
	c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(function(e,tp) Duel.SetLP(tp,Duel.GetLP(tp)-3000) end)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return re~=e end)
	e2:SetTarget(cid.tg)
	e2:SetOperation(cid.op)
	c:RegisterEffect(e2)
end
function cid.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function cid.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function cid.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateAttack()
	if c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,eg:GetSum(Card.GetAttack()))
end
function cid.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x7c4)
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	local ap=Duel.Recover(tp,eg:GetSum(Card.GetAttack()),REASON_EFFECT)
	local ct=c:GetFlagEffectLabel(id)
	if not ct then
		Duel.RegisterFlagEffect(id,RESET_PHASE+PHASE_END,0,1,ap)
	else
		Duel.SetFlagEffectLabel(id,ct+ap)
	end
	if c:GetFlagEffectLabel(id)<3000 then return end
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
