--Medivatale Vinping Beau-Tie
function c16000896.initial_effect(c)
	   --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16000896,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,16000896)
	--e2:SetCondition(aux.exccon)
	e2:SetCost(c16000896.cost2)
	e2:SetTarget(c16000896.target2)
	e2:SetOperation(c16000896.operation2)
	c:RegisterEffect(e2)
	  --become material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(c16000896.mtcon)
	e5:SetOperation(c16000896.mtop)
	c:RegisterEffect(e5)  
end
function c16000896.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.CheckReleaseGroup(tp,c16000896.costfilter,1,e:GetHandler()) end
	local sg=Duel.SelectReleaseGroup(tp,c16000896.costfilter,1,1,e:GetHandler())
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c16000896.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xab5)
end
function c16000896.xxfilter2(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsCode(16000896) and c:IsAbleToDeck()
end
function c16000896.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c16000896.xxfilter2(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c16000896.xxfilter2,tp,LOCATION_REMOVED,0,4,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c16000896.xxfilter2,tp,LOCATION_REMOVED,0,4,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c16000896.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=4 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==4 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c16000896.filter(c,e,tp)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16000896.ffilter(c)
	return c:IsRace(RACE_FAIRY)
end
function c16000896.mtcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetReasonCard()
	return  ec:GetMaterial():IsExists(c16000896.ffilter,1,nil) and  r==REASON_EVOLUTE ~=0
end
function c16000896.mtop(e,tp,eg,ep,ev,re,r,rp)
if Duel.GetFlagEffect(tp,16000896)~=0 then return end
	Duel.Hint(HINT_CARD,0,16000896)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
   e1:SetDescription(aux.Stringid(16000896,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,16000899)
	e1:SetCost(c16000896.cost)
	e1:SetTarget(c16000896.target)
	e1:SetOperation(c16000896.operation)	
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	 if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	rc:RegisterFlagEffect(16000896,RESET_EVENT+RESETS_STANDARD+0x47e0000,0,1)
	end
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(16000896,0))
	Duel.RegisterFlagEffect(tp,16000896,RESET_PHASE+PHASE_END,0,1)
end
function c16000896.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,4,REASON_COST) end
	e:GetHandler():RemoveEC(tp,4,REASON_COST)
end
function c16000896.xxfilter(c)
	return c:IsType(TYPE_MONSTER)
end

function c16000896.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c16000896.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c16000896.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c16000896.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c16000896.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	   local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
if tc:GetLevel()>4 then
		 local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_CHANGE_LEVEL)
		e6:SetValue(4)
		e6:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e6)
	   end
end
	Duel.SpecialSummonComplete()
end

