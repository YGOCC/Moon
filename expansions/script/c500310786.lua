--Paintress Duchumpia
function c500310786.initial_effect(c)
	  --pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c500310786.splimit)
	e2:SetCondition(c500310786.splimcon)
	c:RegisterEffect(e2)

  local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_PZONE)
	--e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetOperation(c500310786.operation666)
	c:RegisterEffect(e3)
  --tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	--e4:SetCountLimit(1,500310786)
	e4:SetCost(c500310786.cost)
	e4:SetTarget(c500310786.target)
	e4:SetOperation(c500310786.operation)
	c:RegisterEffect(e4)
end

function c500310786.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xc50) and not c:IsForbidden()
end
function c500310786.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra()  end
  --  Duel.SendtoExtraP(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_COST)
  Duel.Release(e:GetHandler(),REASON_COST)
end
function c500310786.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c500310786.filter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
end
function c500310786.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c500310786.filter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(500310786,0))
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(500310786,0))
	local tg2=g:Select(tp,1,1,nil)
	tg1:Merge(tg2)
	if tg1:GetCount()==2 then
		Duel.SendtoExtraP(tg1,tp,REASON_EFFECT)
	end
end

function c500310786.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c500310786.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c500310786.operation666(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetReset(RESET_CHAIN)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc52))
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
  local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	Duel.RegisterEffect(e2,tp)
end
