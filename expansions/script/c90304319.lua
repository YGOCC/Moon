--Gemini Urge
function c90304319.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c90304319.target1)
	e1:SetOperation(c90304319.operation)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,90304319+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c90304319.condition)
	e2:SetCost(c90304319.cost)
	e2:SetTarget(c90304319.target2)
	e2:SetOperation(c90304319.operation)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
    --destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetTarget(c90304319.reptg)
	e5:SetValue(c90304319.repval)
	e5:SetOperation(c90304319.repop)
	c:RegisterEffect(e5)
	end	
function c90304319.filter(c) --send 1 Gemini M to the grave to draw 1 card functions
	return c:IsType(TYPE_DUAL) and c:IsAbleToGrave()
end
function c90304319.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and Duel.GetFlagEffect(tp,90304319)==0
		and Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c90304319.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,0)
		and Duel.SelectYesNo(tp,aux.Stringid(90304319,0)) then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.RegisterFlagEffect(tp,90304319,RESET_PHASE+PHASE_END,0,1)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		e:SetLabel(1)
		e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(90304319,1))
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetLabel(0)
	end
end
function c90304319.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c90304319.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,90304319)==0 end
	Duel.RegisterFlagEffect(tp,90304319,RESET_PHASE+PHASE_END,0,1)
end
function c90304319.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c90304319.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c90304319.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c90304319.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,0)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c90304319.repfilter(c,tp) --destroy replace functions
	return c:IsFaceup() and c:IsType(TYPE_DUAL) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c90304319.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c90304319.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(90304319,2))
end
function c90304319.repval(e,c)
	return c90304319.repfilter(c,e:GetHandlerPlayer())
end
function c90304319.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
