--Paintress EX- Destructive ARMANIA
function c160006669.initial_effect(c)
		 --evolute procedure
	aux.AddOrigEvoluteType(c)
	aux.AddEvoluteProc(c,nil,5,c160006669.filter1,c160006669.filter2,1,99)
	c:EnableReviveLimit() 
	--destroy
   -- local e1=Effect.CreateEffect(c)
   -- e1:SetDescription(aux.Stringid(160006669,0))
   -- e1:SetCategory(CATEGORY_DESTROY)
  --  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  --  e1:SetCode(EVENT_BATTLE_START)
  --  e1:SetTarget(c160006669.destg)
  --  e1:SetOperation(c160006669.desop)
	--c:RegisterEffect(e1)
  --disable spsummon
   local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	 e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,160006669)
   e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetTarget(c160006669.thtg)
	e2:SetCost(c160006669.cost)
	e2:SetOperation(c160006669.thop)
	c:RegisterEffect(e2)
		  --atkup

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c160006669.atkval)
	c:RegisterEffect(e4)
end
function c160006669.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsRace(RACE_FAIRY) 
end
function c160006669.filter2(c,ec,tp)
	return  c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsRace(RACE_FAIRY) 
end
function c160006669.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() and tc:IsType(TYPE_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c160006669.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) end
end
function c160006669.costfilter(c)
	return c:IsAbleToRemoveAsCost()  and (c:IsType(TYPE_PENDULUM) and c:IsFaceup())
end
function c160006669.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,2,REASON_COST) and Duel.IsExistingMatchingCard(c160006669.costfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c160006669.costfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RemoveEC(tp,2,REASON_COST)
	c:RegisterFlagEffect(160006669,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end


function c160006669.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
		Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
end
function c160006669.atkval(e,c)
	return Duel.GetMatchingGroupCount(c160006669.atkfilter,c:GetControler(),LOCATION_EXTRA,0,nil,nil)*300
end
function c160006669.atkfilter(c)
	return c:IsFaceup()  and c:IsType(TYPE_PENDULUM)  
end


function c160006669.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return tc:IsPreviousLocation(LOCATION_ONFIELD) and eg:GetCount()==1 and tc:IsSetCard(0xc50) and tc:IsType(TYPE_PENDULUM) 
	  and tc:IsReason(REASON_EFFECT+REASON_DESTROY)
		and tc:GetPreviousControler() end
	tc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
end
function c160006669.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
   if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=eg:GetFirst()
	if tc:IsRelateToEffect(e)  and  Duel.SendtoHand(tc,nil,REASON_EFFECT) ~=0 and tc:IsType(TYPE_NORMAL) and Duel.SelectYesNo(tp,aux.Stringid(6666,7))then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end