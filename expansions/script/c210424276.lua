--Lunar Cycles
local card = c210424276
function card.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(card.target)
	e1:SetOperation(card.activate)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,210424285)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(card.thcost)
	e2:SetTarget(card.gtg)
	e2:SetOperation(card.gop)
	c:RegisterEffect(e2)
end
function card.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function card.gtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,LOCATION_PZONE)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,g:GetCount(),0,0)
end
function card.thfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666) and c:IsAbleToHand()
end
function card.gop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	local ct=Duel.SendtoExtraP(g,2,REASON_EFFECT)
		local hg1=Duel.GetMatchingGroup(card.thfilter1,tp,LOCATION_DECK,0,nil)
	if ct>=1 and hg1:GetCount()>0  then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local shg1=hg1:Select(tp,1,1,nil)
		Duel.SendtoHand(shg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,shg1)
			local hg1=Duel.GetMatchingGroup(card.thfilter1,tp,LOCATION_DECK,0,nil)
	if ct>=2 and hg1:GetCount()>0  then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local shg1=hg1:Select(tp,1,1,nil)
		Duel.SendtoHand(shg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,shg1)
			local hg1=Duel.GetMatchingGroup(card.thfilter1,tp,LOCATION_DECK,0,nil)
	if ct>=3 and hg1:GetCount()>0  then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local shg1=hg1:Select(tp,1,1,nil)
		Duel.SendtoHand(shg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,shg1)
			local hg1=Duel.GetMatchingGroup(card.thfilter1,tp,LOCATION_DECK,0,nil)
	if ct>=4 and hg1:GetCount()>0  then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local shg1=hg1:Select(tp,1,1,nil)
		Duel.SendtoHand(shg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,shg1)
	end
	end
	end
	end
	end

function card.cfilter2(c)
	return c:IsSetCard(0x666) and c:IsDiscardable()
end
function card.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(card.cfilter2,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function card.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,card.cfilter2,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,nil,2,REASON_EFFECT+REASON_DISCARD)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

