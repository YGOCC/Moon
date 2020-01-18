--Azure Magician
function c249001010.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	aux.EnablePendulumAttribute(c,false)
	c:EnableReviveLimit()
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(249001010,1))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c249001010.cost)
	e1:SetTarget(c249001010.target)
	e1:SetOperation(c249001010.operation)
	c:RegisterEffect(e1)
	--attach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(56804361,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c249001010.condition)
	e2:SetTarget(c249001010.target2)
	e2:SetOperation(c249001010.operation2)
	c:RegisterEffect(e2)
	--to pzone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(74892653,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e3:SetCondition(c249001010.pcon)
	e3:SetTarget(c249001010.ptg)
	e3:SetOperation(c249001010.pop)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTarget(c249001010.thtg)
	e4:SetOperation(c249001010.thop)
	c:RegisterEffect(e4)
end
function c249001010.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsSetCard(0x1B7)
end
function c249001010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
		and Duel.IsExistingMatchingCard(c249001010.rfilter,tp,LOCATION_GRAVE,0,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249001010.rfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249001010.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsReason(REASON_COST) or c:IsReason(REASON_EFFECT))
end
function c249001010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c249001010.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249001010.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c249001010.filter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c249001010.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SSet(tp,tc)~=0 then
         local e1=Effect.CreateEffect(e:GetHandler())
         e1:SetType(EFFECT_TYPE_SINGLE)
         e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
         e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	     tc:RegisterEffect(e1)
	     local e2=e1:Clone()
	     e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	     tc:RegisterEffect(e2)
	end
end
function c249001010.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c249001010.filter2(c)
	return c:IsSetCard(0x1B7) and (c:IsFaceup() or not c:IsLocation(LOCATION_GRAVE))
end
function c249001010.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c249001010.filter2),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
end
function c249001010.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c249001010.filter2),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then
    	Duel.Overlay(c,g)
    end
end
function c249001010.pcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)))
		and c:IsPreviousPosition(POS_FACEUP)
end
function c249001010.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
		or Duel.IsExistingMatchingCard(c249001010.filter3,tp,LOCATION_ONFIELD,0,1,nil)) end
end
function c249001010.filter3(c)
	return c:IsSetCard(0x1B7) and c:IsFaceup()
end
function c249001010.pop(e,tp,eg,ep,ev,re,r,rp)
	if (not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and not Duel.IsExistingMatchingCard(c249001010.filter3,tp,LOCATION_ONFIELD,0,1,nil) then return false end
	local g=Duel.SelectMatchingCard(tp,c249001010.filter3,tp,LOCATION_ONFIELD,0,1,1,nil)
    if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c249001010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c249001010.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e1:SetTargetRange(LOCATION_HAND,0)
    e1:SetCountLimit(1,249001010)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    Duel.RegisterEffect(e2,tp)
	if not Duel.IsPlayerCanDiscardDeck(tp,3) then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(Card.IsAbleToHand,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(16404809,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	end
end