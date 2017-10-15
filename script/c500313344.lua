function c500313344.initial_effect(c)
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
	e6:SetTarget(c500313344.splimit)
	e6:SetCondition(c500313344.splimcon)
	c:RegisterEffect(e6)
	--tohand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(500313344,0))
	e0:SetCategory(CATEGORY_TOHAND)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,500313344)
	e0:SetTarget(c500313344.thtg)
	e0:SetOperation(c500313344.thop)
	c:RegisterEffect(e0)

		local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(500313344,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCountLimit(1500313345)
	e1:SetCountLimit(1,500313345)
	e1:SetCost(c500313344.cost)
	e1:SetTarget(c500313344.target)
	e1:SetOperation(c500313344.operation)
	c:RegisterEffect(e1)
		local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e3:SetTarget(c500313344.target2)
	c:RegisterEffect(e3)
		--cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(aux.ritlimit)
	c:RegisterEffect(e4)
	
end
function c500313344.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x185a) or  c:IsRace(RACE_PLANT)  then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c500313344.splimcon(e)
	return not e:GetHandler():IsForbidden()
end

function c500313344.thfilter(c)
	return c:IsSetCard(0x85a)  and c:IsAbleToHand()
end
function c500313344.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() and Duel.IsExistingMatchingCard(c500313344.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c500313344.thop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c500313344.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
 Duel.ConfirmCards(1-tp,g)
end
end
function c500313344.filter(c,tp,ep,val)
	return c:IsFaceup() and c:GetSummonPlayer()~=tp and not c:IsDisabled()
end

function c500313344.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISCARD_COST_CHANGE) then return true end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c500313344.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c500313344.filter,1,nil,tp) end
	local g=eg:Filter(c500313344.filter,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetChainLimit(c500313344.limit(Duel.GetCurrentChain()))
end
function c500313344.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return rp==1-tp and tc:IsFaceup() and not tc:IsDisabled() end
	Duel.SetTargetCard(tc)
	Duel.SetChainLimit(c500313344.limit(Duel.GetCurrentChain()))
end
function c500313344.operation(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    local tc=g:GetFirst()
    while tc do
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
        end
end
function c500313344.limit(ch)
    return function(e,lp,tp)
        return not Duel.GetChainInfo(ch,CHAININFO_TARGET_CARDS):IsContains(e:GetHandler())
    end
end