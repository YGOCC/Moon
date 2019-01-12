--Paintress EX - Surrealist Dali
function c160002424.initial_effect(c)
	  --evolute procedure
	aux.EnablePendulumAttribute(c)
	aux.AddOrigEvoluteType(c)
	aux.AddEvoluteProc(c,nil,7,c160002424.filter1,c160002424.filter2,2,99)
	c:EnableReviveLimit()
	  --atk down
	 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c160002424.atktg)
	e1:SetValue(c160002424.val)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(160002424,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON)
	e2:SetCountLimit(1)
	e2:SetCondition(c160002424.condition)
	e2:SetCost(c160002424.cost)
	e2:SetTarget(c160002424.target)
	e2:SetOperation(c160002424.operation)
	c:RegisterEffect(e2)
	   local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCategory(CATEGORY_DISABLE+CATEGORY_TOHAND)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCountLimit(1)
	e5:SetCondition(c160002424.condition2)
	e5:SetTarget(c160002424.target2)
	e5:SetOperation(c160002424.operation2)
	c:RegisterEffect(e5)
end

function c160002424.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c160002424.filter2(c,ec,tp)
	return c:IsRace(RACE_FAIRY)
end

function c160002424.atktg(e,c)
	return c:IsType(TYPE_EFFECT)
end
function c160002424.val(e,c)
	 return Duel.GetMatchingGroupCount(c160002424.ctfilter,e:GetHandler():GetControler(),LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_EXTRA,nil)*-300
end
function c160002424.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT)
end

function c160002424.filter(c)
	return c:IsType(TYPE_EFFECT)
end
function c160002424.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(c160002424.filter,1,nil)
end
function c160002424.costfilter(c)
	return c:IsAbleToRemoveAsCost() and not c:IsType(TYPE_EFFECT) and (c:IsType(TYPE_PENDULUM) and c:IsFaceup())
end
function c160002424.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,4,REASON_COST) and Duel.IsExistingMatchingCard(c160002424.costfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c160002424.costfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RemoveEC(tp,4,REASON_COST)
	c:RegisterFlagEffect(160002424,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c160002424.target(e,tp,eg,ep,ev,re,r,rp,chk)
	  local c=e:GetHandler()
	if chk==0 then return e:GetHandler():GetFlagEffect(160002424)==0 end
	local g=eg:Filter(c160002424.filter,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
		c:RegisterFlagEffect(160002424,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c160002424.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c160002424.filter,nil)
	Duel.NegateSummon(g)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c160002424.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end

function c160002424.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	  local c=e:GetHandler()
	if chk==0 then return e:GetHandler():GetFlagEffect(160002424)==0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
		c:RegisterFlagEffect(160002424,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c160002424.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		  Duel.SendtoHand(eg,nil,REASON_EFFECT)
	end
end

