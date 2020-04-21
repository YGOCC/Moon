--Medivatale Sunangel
function c16000840.initial_effect(c)
  --remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16000840,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,0x11e0)
	e1:SetCountLimit(1,16000840)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c16000840.cost)
	e1:SetTarget(c16000840.target)
	e1:SetOperation(c16000840.operation)
	c:RegisterEffect(e1)  
  --become material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(c16000840.condition2)
	e5:SetOperation(c16000840.operation2)
	c:RegisterEffect(e5) 
end
function c16000840.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c16000840.filter(c,e,tp)
	return c:IsType(TYPE_EVOLUTE) and c:IsSetCard(0xab5) and c:IsSpecialSummonable(SUMMON_TYPE_SPECIAL+388)
end
function c16000840.target(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return Duel.IsExistingMatchingCard(c16000840.filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c16000840.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16000840.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
	   Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_SPECIAL+388)
	end
end
function c16000840.ffilter(c)
	return c:IsRace(RACE_FAIRY)
end

function c16000840.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetReasonCard()
	return ec:GetMaterial():IsExists(c16000840.ffilter,1,nil) and  r==REASON_EVOLUTE
end
function c16000840.operation2(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetFlagEffect(tp,16000840)~=0 then return end
	Duel.Hint(HINT_CARD,0,16000840) 
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(16000840,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCountLimit(1,16000841)
	e1:SetCost(c16000840.cost3)
	e1:SetTarget(c16000840.target3)
	e1:SetOperation(c16000840.operation3)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	rc:RegisterFlagEffect(16000840,RESET_EVENT+RESETS_STANDARD+0x47e0000,0,1)
	end
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(16000840,0))
	Duel.RegisterFlagEffect(tp,16000840,RESET_PHASE+PHASE_END,0,1)
end
function c16000840.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,3,REASON_COST) end
	e:GetHandler():RemoveEC(tp,3,REASON_COST)
end
function c16000840.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	  if chkc then return chkc:IsOnField() and Card.IsAbleToGrave(chkc) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c16000840.fukfilter(c)
	return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_EFFECT)
end
function c16000840.operation3(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
