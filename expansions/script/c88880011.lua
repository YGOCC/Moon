--Number C300: Omega Galaxy-Eyes Ultra Photonic Tachyon Dragon
function c88880011.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x888),5,3)
	c:EnableReviveLimit()
--(1) Indes by battle and card effect
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e1:SetValue(1)
  c:RegisterEffect(e1)
  local e2=e1:Clone()
  e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  c:RegisterEffect(e2)
  --(2) Negate Spell/Trap/Monster
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(1,0))
  e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetCode(EVENT_CHAINING)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCondition(c88880011.discon)
  e3:SetCost(c88880011.discost)
  e3:SetTarget(c88880011.distg)
  e3:SetOperation(c88880011.disop)
  c:RegisterEffect(e3)
  --(3) Draw
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(1,1))
  e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e4:SetType(EFFECT_TYPE_QUICK_O)
  e4:SetCode(EVENT_FREE_CHAIN)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCondition(c88880011.drcon)
  e4:SetCost(c88880011.drcost)
  e4:SetTarget(c88880011.drtg)
  e4:SetOperation(c88880011.drop)
  c:RegisterEffect(e4)
  --(4) Gain ATK
  local e5=Effect.CreateEffect(c)
  e5:SetDescription(aux.Stringid(1,2))
  e5:SetCategory(CATEGORY_TODECK)
  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e5:SetCode(EVENT_BATTLE_CONFIRM)
  e5:SetCondition(c88880011.atkcon)
  e5:SetCost(c88880011.drcost)
  e5:SetTarget(c88880011.atktg)
  e5:SetOperation(c88880011.atkop)
  c:RegisterEffect(e5)
  --(5) spsummon limit
  local e6=Effect.CreateEffect(c)
  e6:SetType(EFFECT_TYPE_SINGLE)
  e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e6:SetCode(EFFECT_SPSUMMON_CONDITION)
  e6:SetValue(c88880011.splimit)
  c:RegisterEffect(e5)
end
c88880011.xyz_number=300
--(2) Negate Spell/Trap
function c88880011.discon(e,tp,eg,ep,ev,re,r,rp)
  return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
  and ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c88880011.discost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
  Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c88880011.distg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
  if re:GetHandler():IsRelateToEffect(re) then
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
  end
end
function c88880011.disop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
	Duel.Destroy(eg,REASON_EFFECT)
  end
end
--(3) Draw
function c88880011.drcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetLP(tp)<=2000
end
function c88880011.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88880011.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(2)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c88880011.drop(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  if Duel.Draw(p,d,REASON_EFFECT)~=0 and c:IsFaceup() and c:IsRelateToEffect(e) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	e1:SetValue(1500)
	c:RegisterEffect(e1)
  end
end
--(4) Gain ATK
function c88880011.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  e:SetLabelObject(bc)
  return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle()
end
function c88880011.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local tc=e:GetLabelObject()
  if chkc then return chkc==tc end
  if chk==0 then return tc:IsOnField() and tc:IsCanBeEffectTarget(e) end
  Duel.SetTargetCard(tc)
end
function c88880011.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc and c:IsRelateToEffect(e) and c:IsFaceup() then
	local atk=tc:GetAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk+1000)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
  end
end
--(5) spsummon limit
function c88880011.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x95)
end