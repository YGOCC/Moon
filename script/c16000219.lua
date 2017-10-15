--Bloom Maiden of Fiber Vine
function c16000219.initial_effect(c)
--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--splimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetTargetRange(1,0)
	e6:SetTarget(c16000219.splimit)
	e6:SetCondition(c16000219.splimcon)
	c:RegisterEffect(e6)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16000219,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCondition(c16000219.descon)
	e1:SetTarget(c16000219.destg)
	e1:SetOperation(c16000219.desop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetDescription(aux.Stringid(16000219,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,16000219)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c16000219.condition2)
	--e2:SetCost(c16000219.cost2)
	e2:SetTarget(c16000219.target)
	e2:SetOperation(c16000219.operation2)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.ritlimit)
	c:RegisterEffect(e3)
--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16000219,0))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	--e4:SetCountLimit(1,16000219)
	e4:SetCondition(c16000219.dkcon)
	e4:SetTarget(c16000219.dktg)
	e4:SetOperation(c16000219.dkop)
		e4:SetLabelObject(e2)
	c:RegisterEffect(e4)
	
end

function c16000219.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x185a) or  c:IsRace(RACE_PLANT)  then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c16000219.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c16000219.condition2(e,tp,eg,ep,ev,re,r,rp)
			local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then tc,bc=bc,tc end
	if tc:IsSetCard(0x185a) and bit.band(bc:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL then
		e:SetLabelObject(bc)
		return true
	else return false end
end
--function c16000219.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	--if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	--Duel.SendtoGrave(e:GetHandler(),REASON_COST)
--end
function c16000219.cfilter2(c)
	return c:IsFaceup()
end
function c16000219.target(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return e:GetHandler():IsDestructable()
and Duel.IsExistingMatchingCard(c16000219.cfilter2,tp,0,LOCATION_MZONE,1,nil) end
end
function c16000219.operation2(e,tp,eg,ep,ev,re,r,rp,chk)
local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	local g=Duel.GetMatchingGroup(c16000219.cfilter2,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end



function c16000219.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bit.band(bc:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c16000219.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c16000219.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.SendtoHand(bc,nil,REASON_EFFECT)
	end
end
function c16000219.dkcon(e,tp,eg,ep,ev,re,r,rp)
	return re~=e:GetLabelObject()
end
function c16000219.dktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16000219.cfilter,tp,LOCATION_EXTRA,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c16000219.cfilter,tp,LOCATION_EXTRA,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c16000219.dkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_EXTRA,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c16000219.cfilter(c)
	return c:IsFaceup() and  c:IsSetCard(0x185a)  and c:IsAbleToDeck()
end