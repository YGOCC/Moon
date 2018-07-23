--Struggle of the Army
function c600000023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c600000023.thtg)
	e1:SetOperation(c600000023.thop)
	c:RegisterEffect(e1)
	--Set Ammunition from Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(600000023,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,60000023)
	e2:SetCondition(c600000023.setcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c600000023.settg)
	e2:SetOperation(c600000023.setop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(600000023,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCondition(c600000023.drcon)
	e3:SetTarget(c600000023.drtg)
	e3:SetOperation(c600000023.drop)
	c:RegisterEffect(e3)
end
function c600000023.thfilter(c)
	return c:IsSetCard(0x24a8) and c:IsAbleToHand()
end
function c600000023.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c600000023.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c600000023.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c600000023.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	e:GetHandler():RegisterFlagEffect(600000023,RESET_PHASE+PHASE_END,0,1)
end
function c600000023.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x24a8)
end
function c600000023.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c600000023.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c600000023.setfilter(c)
	return c:IsCode(600000024) and c:IsSSetable()
end
function c600000023.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c600000023.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c600000023.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c600000023.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
function c600000023.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(600000023)~=0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)>Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
		and Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c600000023.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,2,tp,0)
end
function c600000023.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	e:GetHandler():ResetFlagEffect(600000023)
end