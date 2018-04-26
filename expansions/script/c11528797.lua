--Ripple Current
function c11528797.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11528797)
	e1:SetHintTiming(0,TIMING_TOHAND)
	e1:SetCost(c11528797.cost)
	e1:SetTarget(c11528797.target)
	e1:SetOperation(c11528797.activate)
	c:RegisterEffect(e1)
end
function c11528797.costfilter(c)
	return c:IsSetCard(0x806) and c:IsAttackAbove(2000)
end
function c11528797.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c11528797.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c11528797.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c11528797.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)
end
function c11528797.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(p,g)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
		local sg=g:Select(p,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		Duel.ShuffleHand(1-p)
	end
end