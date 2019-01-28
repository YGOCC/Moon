--Subzero Crystal - Guardian Suplimanate
function c88890004.initial_effect(c)
	c:EnableReviveLimit()
	--(1) Special Summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c88890004.splimit)
	c:RegisterEffect(e1)
	--(2) Excavate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88890004,0))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c88890004.excatg)
	e2:SetOperation(c88890004.excaop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c88890004.excacon)
	c:RegisterEffect(e3)
	--(3) Pay or Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(88890004,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c88890004.paycon)
	e4:SetOperation(c88890004.payop)
	c:RegisterEffect(e4)
	--(4) To hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(88890004,2))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCost(c88890004.thcost)
	e5:SetTarget(c88890004.thtg)
	e5:SetOperation(c88890004.thop)
	c:RegisterEffect(e5)
	--(5) Place in S/T Zone
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetCondition(c88890004.stzcon)
	e6:SetOperation(c88890004.stzop)
	c:RegisterEffect(e6)
	--(7) add
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(88890004,4))
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCondition(c88890004.thcon)
	e7:SetTarget(c88890004.thtg1)
	e7:SetOperation(c88890004.thop1)
	c:RegisterEffect(e7)
end
--(1) Special Summon condition
function c88890004.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x902)
end
--(3) Excavate
function c88890004.excacon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_SPELL+TYPE_CONTINUOUS) and not e:GetHandler():IsType(TYPE_EQUIP)
end
function c88890004.excatg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,3) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,1-tp,1)
end
function c88890004.tgfilter(c)
  return c:IsType(TYPE_MONSTER)
end
function c88890004.excaop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(1-tp,3) then return end
	Duel.ConfirmDecktop(1-tp,3)
	local g=Duel.GetDecktopGroup(1-tp,3)
	local sg=g:Filter(c88890004.tgfilter,nil)
	if sg:GetCount()>0 then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)
		local og=Duel.GetOperatedGroup()
		local ogct=og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,sg:GetCount()*500)
		Duel.Recover(tp,sg:GetCount()*500,REASON_EFFECT)
	end
	Duel.ShuffleDeck(1-tp)
end
--(3) Pay or Destroy
function c88890004.paycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c88890004.payop(e,tp,eg,ep,ev,re,r,rp)
	Duel.HintSelection(Group.FromCards(e:GetHandler()))
	if Duel.CheckLPCost(tp,1000) and Duel.SelectYesNo(tp,aux.Stringid(88890004,1)) then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(88890004,5))
		Duel.PayLPCost(tp,1000)
	else
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(88890004,6))
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
--(4) To hand
function c88890004.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c88890004.thfilter(c)
	return c:IsSetCard(0x902) and c:GetType()==TYPE_SPELL+TYPE_RITUAL and c:IsAbleToHand()
end
function c88890004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88890004.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88890004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88890004.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--(5) Place in S/T Zone
function c88890004.stzcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c88890004.stzop(e,tp,eg,ep,ev,re,r,rp)
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
function c88890004.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end
function c88890004.thfilter1(c)
	return c:IsSetCard(0x902) and c:IsAbleToHand()
end
function c88890004.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88890004.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88890004.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88890004.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end