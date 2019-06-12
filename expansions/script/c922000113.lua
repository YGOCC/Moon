--Orcadragon - Ascended Ryuko Crimson
local m=922000113
local cm=_G["c"..m]
local id=m
function cm.initial_effect(c)
	--Pendulum Effects
	aux.EnablePendulumAttribute(c)
	--(p1) While you do not have "Orcadragon - Ryuko Crimson" in your other Pendulum Zone: you cannot Pendulum Summon monsters, except "Orcadragon" monster.
	local ep1=Effect.CreateEffect(c)
	ep1:SetType(EFFECT_TYPE_FIELD)
	ep1:SetRange(LOCATION_PZONE)
	ep1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ep1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ep1:SetTargetRange(1,0)
	ep1:SetCondition(cm.spcon)
	ep1:SetTarget(cm.splimit)
	c:RegisterEffect(ep1)
	--(p2) Once per turn, you can target 1 "Orcadragon" monster you control: It gains 1500 ATK until the end of the turn.
	local ep2=Effect.CreateEffect(c)
	ep2:SetCategory(CATEGORY_ATKCHANGE)
	ep2:SetType(EFFECT_TYPE_IGNITION)
	ep2:SetRange(LOCATION_PZONE)
	ep2:SetCode(EVENT_FREE_CHAIN)
	ep2:SetCountLimit(1)
	ep2:SetTarget(cm.atktg)
	ep2:SetOperation(cm.atkop)
	c:RegisterEffect(ep2)
	--Monster Effects
	--(1) You can tribute 1 "Orcadragon - Ryuko Crimson" you control to Special Summon this card. 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.hspcon)
	e1:SetOperation(cm.hspop)
	c:RegisterEffect(e1)
	--(2) If another "Orcadragon" monster you control is involved in battle: that card gains half this cards original ATK until the end of the damage step.
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.descon)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
end
--Pendulum Effects
--(1)
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_PZONE,0,1,e:GetHandler(),id+6)
end
function cm.filter(c)
	return c:IsSetCard(0x904)
end
function cm.splimit(e,c,tp,sumtp,sumpos)
	if not (bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM) then return end
	return not cm.filter(c)
end
--(2)
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1500)
	e1:SetReset(RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end
--Monster Effects
--(1)
function cm.hspfilter(c,ft,tp)
	return c:IsCode(id+6)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.CheckReleaseGroup(tp,cm.hspfilter,1,nil,ft,tp)
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroup(tp,cm.hspfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
--(2)
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:GetControler()==tp or d:GetControler()==tp then
	return a:IsSetCard(0x904) and a~=e:GetHandler()
	else
	return false
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local atk=c:GetAttack()
	if a:GetControler()==tp then
		tc=Duel.GetAttacker()
	elseif d:GetControler()==tp then
		tc=Duel.GetAttackTarget()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
	e1:SetValue(atk/2)
	tc:RegisterEffect(e1)
end
