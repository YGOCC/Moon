--Paintress EX: Coupé-out Matissa
function c500316141.initial_effect(c)
	 aux.AddOrigEvoluteType(c)
	c:EnableReviveLimit()
  aux.AddEvoluteProc(c,nil,7,c500316141.filter1,c500316141.filter2,c500316141.filter3,2,99)  
   --remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(500316141,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	--e1:SetHintTiming(0,0x11e0)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
	e1:SetCost(c500316141.cost)
	e1:SetTarget(c500316141.target)
	e1:SetOperation(c500316141.operation)
	c:RegisterEffect(e1)
	   --Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(500316141,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,500316141)
   e2:SetCost(c500316141.cost2)
	e2:SetCondition(c500316141.condition2)
	e2:SetTarget(c500316141.target2)
	e2:SetOperation(c500316141.operation2)
	c:RegisterEffect(e2)
end
function c500316141.filter3(c,ec,tp)
	return not c:IsType(TYPE_EFFECT)
end

function c500316141.costfilter(c)
	return c:IsAbleToRemoveAsCost() and (c:IsType(TYPE_PENDULUM) and c:IsFaceup())
end
function c500316141.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,3,REASON_COST) and Duel.IsExistingMatchingCard(c500316141.costfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c500316141.costfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RemoveEC(tp,3,REASON_COST)
	c:RegisterFlagEffect(500316141,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c500316141.filterxx(c,ec,tp)
	return c:IsType(TYPE_EFFECT) and c:IsAbleToRemove()
end
function c500316141.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()~=tp and chkc:GetLocation()==LOCATION_GRAVE and c500316141.filterxx(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c500316141.filterxx,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c500316141.filterxx,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c500316141.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
  local c=e:GetHandler()	   
  if not (c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) ~=0) then return end
	local atk=tc:GetTextAttack()/2
	local def=tc:GetTextDefense()/2
	if atk>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	end
end


function c500316141.filter1(c,ec,tp)
	return c:IsRace(RACE_FAIRY) or c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c500316141.filter2(c,ec,tp)
	return c:IsRace(RACE_FAIRY) or c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c500316141.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return  Duel.IsExistingMatchingCard(c500316141.costfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c500316141.costfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	c:RegisterFlagEffect(500316141,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c500316141.condition2(e,tp,eg,ep,ev,re,r,rp)
	   return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c500316141.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	  if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c500316141.operation2(e,tp,eg,ep,ev,re,r,rp)
	   Duel.NegateActivation(ev)
	end