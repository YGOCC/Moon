--Sarah The K , Pirncess of Gust Vine
function c500311003.initial_effect(c)
aux.AddOrigEvoluteType(c)
	aux.AddEvoluteProc(c,nil,4,c500311003.filter1,c500311003.filter1,2,99)
	c:EnableReviveLimit()
		--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	   -- --Negate
 --   local e2=Effect.CreateEffect(c)
  --  e2:SetDescription(aux.Stringid(500311003,0))
  --  e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
  --  e2:SetType(EFFECT_TYPE_QUICK_O)
  --  e2:SetCode(EVENT_CHAINING)
 --   e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
 --   e2:SetRange(LOCATION_MZONE)
--  e2:SetCondition(c500311003.condition)
 --   e2:SetCost(c500311003.cost)
--  e2:SetTarget(c500311003.target)
 --   e2:SetOperation(c500311003.operation)
 --   c:RegisterEffect(e2)
 --   local e3=e2:Clone()
 --	e3:SetCondition(c500311003.condition3)
	 --   c:RegisterEffect(e3)
   --pierce
 local e4=Effect.CreateEffect(c)
   e4:SetType(EFFECT_TYPE_SINGLE)
 e4:SetCode(EFFECT_PIERCE)
   c:RegisterEffect(e4)
  local e5=Effect.CreateEffect(c)
  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
  e5:SetCondition(c500311003.damcon)
  e5:SetOperation(c500311003.damop)
  c:RegisterEffect(e5)
	   --cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
	
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(500311003,1))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetHintTiming(0,TIMING_DRAW_PHASE)
	e6:SetCountLimit(1)
	e6:SetCondition(c500311003.actcon)
	e6:SetCost(c500311003.actcost)
	e6:SetOperation(c500311003.actop)
	c:RegisterEffect(e6)

end
function c500311003.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_WIND) or c:IsRace(RACE_PLANT)
end

function c500311003.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c==Duel.GetAttacker() and Duel.GetAttackTarget() and Duel.GetAttackTarget():IsDefensePos()
end
function c500311003.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c500311003.condition(e,tp,eg,ep,ev,re,r,rp)
	if not  e:GetHandler():GetMaterial():IsExists(c500311003.pmfilter,1,nil) and  e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if  re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	return ex and tg~=nil
end
function c500311003.condition3(e,tp,eg,ep,ev,re,r,rp)
	if not  e:GetHandler():GetMaterial():IsExists(c500311003.pmfilter,1,nil) and  e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if  re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil
end
function c500311003.pmfilter(c)
	return c:IsType(TYPE_FUSION)
end
function c500311003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,4,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x88,4,REASON_COST)
end
function c500311003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c500311003.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end


function c500311003.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c500311003.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	  local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,4,REASON_COST) and  Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()
	 Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
	e:GetHandler():RemoveEC(tp,2,REASON_COST)
	c:RegisterFlagEffect(500311003,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c500311003.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(0,1)
	e1:SetTarget(c500311003.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c500311003.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_EVOLUTE)
end