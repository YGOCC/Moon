--Subzero Crystal - Guardian Pheoneta
function c88890008.initial_effect(c)
	c:EnableReviveLimit()
	--(1) Special Summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c88890008.splimit)
	c:RegisterEffect(e1)
	--(2) Effect for card
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c88890008.condition)
	e2:SetOperation(c88890008.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e3)
	--(3) Pay or Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(88890008,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c88890008.paycon)
	e4:SetOperation(c88890008.payop)
	c:RegisterEffect(e4)
	--(4) To hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(88890008,2))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCost(c88890008.thcost)
	e5:SetTarget(c88890008.thtg)
	e5:SetOperation(c88890008.thop)
	c:RegisterEffect(e5)
	--(5) Place in S/T Zone
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetCondition(c88890008.stzcon)
	e6:SetOperation(c88890008.stzop)
	c:RegisterEffect(e6)
	--(7) add
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(88890008,4))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCondition(c88890008.thcon)
	e7:SetTarget(c88890008.thtg1)
	e7:SetOperation(c88890008.thop1)
	c:RegisterEffect(e7)
end
--(1) Special Summon condition
function c88890008.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x902)
end
--(2) Effect for card
function c88890008.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0
	--if e:GetLocation()==LOCATION_SZONE then
		--return e:GetHandler():IsType(TYPE_SPELL+TYPE_CONTINUOUS) and not e:GetHandler():IsType(TYPE_EQUIP)
	--end
end
function c88890008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88890008.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c88890008.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabelObject(g)
end
function c88890008.cfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x902)
end
function c88890008.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c88890008.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject(g)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetValue(c88890008.indval)
	e1:SetReset(RESET_CHAIN)
	e1:SetLabel(cid)
	Duel.RegisterEffect(e1,tp)
	if g==c:IsType(TYPE_MONSTER) then
		local rec=g:GetAttack()/2
		Duel.Recover(tp,rec,REASON_EFFECT)
	end
end
function c88890008.indval(e,re,rp)
	return Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)==e:GetLabel()
end
--(3) Pay or Destroy
function c88890008.paycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c88890008.payop(e,tp,eg,ep,ev,re,r,rp)
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
	if Duel.CheckLPCost(tp,600) and Duel.SelectYesNo(tp,aux.Stringid(88890008,1)) then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(88890008,5))
		Duel.PayLPCost(tp,600)
	else
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(88890008,6))
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
--(4) To hand
function c88890008.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c88890008.thfilter(c)
	return c:IsSetCard(0x902) and c:GetType()==TYPE_SPELL+TYPE_RITUAL and c:IsAbleToHand()
end
function c88890008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88890008.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88890008.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88890008.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--(5) Place in S/T Zone
function c88890008.stzcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c88890008.stzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Continuous Spell
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	Duel.RaiseEvent(c,EVENT_CUSTOM+88890010,e,0,tp,0,0)
end
--(7) add
function c88890008.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end
function c88890008.thfilter1(c)
	return c:IsSetCard(0x902) and c:IsAbleToHand()
end
function c88890008.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88890008.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88890008.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88890008.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end