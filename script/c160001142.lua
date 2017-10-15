--Trishi, Brother of Fiber Vine
function c160001142.initial_effect(c)
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
	e6:SetTarget(c160001142.splimit)
	e6:SetCondition(c160001142.splimcon)
	c:RegisterEffect(e6)
		--atk down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(160001142,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c160001142.cost)
	e1:SetTarget(c160001142.target)
	e1:SetOperation(c160001142.operation)
	c:RegisterEffect(e1)
		--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(160001142,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	--e2:SetCost(c160001142.thcost)
	e2:SetTarget(c160001142.thtg)
	e2:SetOperation(c160001142.thop)
	c:RegisterEffect(e2)
		--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.ritlimit)
	c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(160001142,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCost(c160001142.cost2)
	e4:SetOperation(c160001142.activate2)
	c:RegisterEffect(e4)
end
function c160001142.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c160001142.cfilter,tp,LOCATION_EXTRA,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c160001142.cfilter,tp,LOCATION_EXTRA,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c160001142.cfilter(c)
	return c:IsFaceup()  and c:IsSetCard(0x185a)  and c:IsAbleToRemoveAsCost()
end
function c160001142.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x185a) or  c:IsRace(RACE_PLANT)  then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c160001142.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
--function c160001142.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	--if chk==0 then return e:GetHandler():IsDiscardable() end
	--Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
--end
function c160001142.thfilter(c)
	return  c:IsFaceup()  and c:IsSetCard(0x85a)  and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c160001142.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return e:GetHandler():IsDestructable()
	and Duel.IsExistingMatchingCard(c160001142.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c160001142.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c160001142.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
 Duel.ConfirmCards(1-tp,g)
end
end

function c160001142.ssfilter(c,tp,ep,val)
	return c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0
end
function c160001142.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
	c:RegisterFlagEffect(160001142,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c160001142.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c160001142.ssfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c160001142.ssfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c160001142.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e4)
		local e5=e3:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e5)
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_DISABLE)
		e6:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e6)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_DISABLE_EFFECT)
		e7:SetValue(RESET_TURN_SET)
		e7:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e7)
			local e8=Effect.CreateEffect(c)
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_SET_ATTACK_FINAL)
		e8:SetValue(0)
		e8:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e8)
	end
end
function c160001142.activate2(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler()

		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetTargetRange(LOCATION_ONFIELD,0)
		e2:SetTarget(c160001142.indtg)
		e2:SetValue(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
end
function c160001142.indtg(e,c)
	return  c:IsSetCard(0x185a)
end