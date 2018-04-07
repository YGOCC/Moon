--Number 300: Galaxy-Eyes Photonic Tachyon Dragon (XyLeS)
local m=47
local cm=_G["c"..m]
function cm.initial_effect(c)
--Xyz Materials
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xba),4,2)
  c:EnableReviveLimit()
  --(1) Indes by battle
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e1:SetValue(1)
  c:RegisterEffect(e1)
  --(2) Negate Spell/Trap
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(1,0))
  e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_QUICK_O)
  e2:SetCode(EVENT_CHAINING)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCondition(c1.discon)
  e2:SetCost(c1.discost)
  e2:SetTarget(c1.distg)
  e2:SetOperation(c1.disop)
  c:RegisterEffect(e2)
  --(3) Draw
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(1,1))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetCode(EVENT_FREE_CHAIN)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCondition(c1.drcon)
  e3:SetCost(c1.drcost)
  e3:SetTarget(c1.drtg)
  e3:SetOperation(c1.drop)
  c:RegisterEffect(e3)
  --(4) Gain ATK
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(1,2))
  e4:SetCategory(CATEGORY_TODECK)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e4:SetCode(EVENT_BATTLE_CONFIRM)
  e4:SetCondition(c1.atkcon)
  e4:SetCost(c1.drcost)
  e4:SetTarget(c1.atktg)
  e4:SetOperation(c1.atkop)
  c:RegisterEffect(e4)
end
c1.xyz_number=300
--(2) Negate Spell/Trap
function c1.discon(e,tp,eg,ep,ev,re,r,rp)
  return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
  and ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c1.discost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
  Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c1.distg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
  if re:GetHandler():IsRelateToEffect(re) then
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
  end
end
function c1.disop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
    Duel.Destroy(eg,REASON_EFFECT)
  end
end
--(3) Draw
function c1.drcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetLP(tp)<=2000
end
function c1.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c1.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(1)
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c1.drop(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  if Duel.Draw(p,d,REASON_EFFECT)~=0 and c:IsFaceup() and c:IsRelateToEffect(e) then
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
    e1:SetValue(1000)
    c:RegisterEffect(e1)
  end
end
--(4) Gain ATK
function c1.atkcon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  e:SetLabelObject(bc)
  return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle()
end
function c1.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local tc=e:GetLabelObject()
  if chkc then return chkc==tc end
  if chk==0 then return tc:IsOnField() and tc:IsCanBeEffectTarget(e) end
  Duel.SetTargetCard(tc)
end
function c1.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc and c:IsRelateToEffect(e) and c:IsFaceup() then
    local atk=tc:GetAttack()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(atk)
    e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
  end
end