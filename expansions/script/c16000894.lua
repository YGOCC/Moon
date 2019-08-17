--Medivatale SnowBlake
function c16000894.initial_effect(c)
aux.AddXyzProcedure(c,aux.FilterBoolFunction(c16000894.xyzfilter),3,2)
	c:EnableReviveLimit()
	   --remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c16000894.rmcon)
	e1:SetCost(c16000894.rmcost)
	e1:SetTarget(c16000894.rmtg)
	e1:SetOperation(c16000894.rmop)
	c:RegisterEffect(e1)
 --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16000894,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	--e2:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,16000894)
	e2:SetCondition(c16000894.condition2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c16000894.target2)
	e2:SetOperation(c16000894.operation)
	c:RegisterEffect(e2)
   --gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c16000894.mtcon)
	e4:SetOperation(c16000894.mtop)
	c:RegisterEffect(e4)	
end
function c16000894.xyzfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) or c:IsRace(RACE_FAIRY)
end
function c16000894.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c16000894.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c16000894.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,4) end
end
function c16000894.filter(c)
	return c:IsAbleToHand() and c:IsSetCard(0xab5)
end
function c16000894.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,4) then return end
	Duel.ConfirmDecktop(tp,4)
	local g=Duel.GetDecktopGroup(tp,4)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(c16000894.filter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(16000894,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c16000894.filter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REVEAL)
	end
end
function c16000894.filter2(c)
	
	return c:IsSetCard(0xab5) and c:IsAbleToDeck()
end
function c16000894.condition2(e,tp,eg,ep,ev,re,r,rp)
	  if c==nil then return true end
	local tp=c:GetControler()
	return  Duel.IsExistingMatchingCard(c16000894.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c16000894.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c16000894.filter2(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c16000894.filter2,tp,LOCATION_GRAVE,0,7,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c16000894.filter2,tp,LOCATION_GRAVE,0,7,7,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c16000894.cfilter(c)
	return c:IsFaceup() and  not (c:GetSummonLocation()==LOCATION_EXTRA  and c:IsType(TYPE_EFFECT))
end

function c16000894.operation(e,tp,eg,ep,ev,re,r,rp)
	 local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=7 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==7 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c16000894.ffilter(c)
	return c:IsRace(RACE_FAIRY)
end
function c16000894.mtcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetReasonCard()
	return  ec:GetMaterial():IsExists(c16000894.ffilter,1,nil) and  r==REASON_EVOLUTE ~=0
function c16000894.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,16000894)~=0 then return end
	Duel.Hint(HINT_CARD,0,16000894)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(16000894,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c16000894.negcon)
	e1:SetCost(c16000894.negcost)
	e1:SetTarget(c16000894.negtg)
	e1:SetOperation(c16000894.negop)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	rc:RegisterFlagEffect(16000894,RESET_EVENT+RESETS_STANDARD+0x47e0000,0,1)
	end
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(16000894,0))
	Duel.RegisterFlagEffect(tp,16000894,RESET_PHASE+PHASE_END,0,1)
end
function c16000894.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+388)
end

function c16000894.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c16000894.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,4,REASON_COST) end
	e:GetHandler():RemoveEC(tp,4,REASON_COST)
end
function c16000894.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c16000894.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end