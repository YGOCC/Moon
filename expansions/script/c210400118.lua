--created by LionHeartKIng, coded by Lyris, art from Yu-Gi-Oh! BAM's "Mirror" Power-up & "Cyber Dragon"
--襲雷竜－銀
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return eg:IsExists(cid.cfilter,1,nil,tp) end)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetTarget(cid.tg)
	e1:SetOperation(cid.op)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EVENT_ATTACK_ANNOUNCE)
	e0:SetCondition(cid.descon)
	e0:SetTarget(cid.destg)
	e0:SetOperation(cid.desop)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,id)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
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
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cid.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateAttack()
	if c:IsRelateToEffect(e) and c:IsDestructable() then
		Duel.BreakEffect()
		Duel.Destroy(c,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function cid.cfilter(c,tp)
	return (c:IsPreviousLocation(LOCATION_MZONE) or c:IsType(TYPE_MONSTER)) and (c:IsPreviousPosition(POS_FACEUP) or c:GetPreviousControler()==tp) and c:IsSetCard(0x7c4) and c:IsType(TYPE_MONSTER)
end
function cid.spfilter(c,e,tp)
	return c:IsSetCard(0x7c4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and not c:IsCode(id)
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cid.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
