--PROGRAM Soraka
function c11000176.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCost(c11000176.reccost)
	e2:SetTarget(c11000176.target)
	e2:SetOperation(c11000176.activate)
	c:RegisterEffect(e2)
	--return to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(31038159,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,11000176)
	e3:SetTarget(c11000176.tdtg)
	e3:SetOperation(c11000176.tdop)
	c:RegisterEffect(e3)
end
function c11000176.filter(c)
	return c:IsSetCard(0x1F7)
end
function c11000176.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c11000176.filter,1,nil) end
	local sg=Duel.SelectReleaseGroup(tp,c11000176.filter,1,1,nil)
	local tc=sg:GetFirst()
	local atk=tc:GetBaseAttack()
	Duel.Release(tc,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11000176,0))
	local sel=Duel.SelectOption(tp,aux.Stringid(11000176,1))
	if sel==0 then e:SetLabel(atk) end
end
function c11000176.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())
end
function c11000176.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c11000176.tdfilter(c)
	return c:IsSetCard(0x1F7) and c:IsAbleToDeck()
end
function c11000176.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11000176.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c11000176.tdfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetCount()*500)
end
function c11000176.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11000176.tdfilter,tp,LOCATION_GRAVE,0,nil)
	local ct1=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Recover(tp,ct1*500,REASON_EFFECT)
end
