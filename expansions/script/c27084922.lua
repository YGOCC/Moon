--Exostorm Perimeter Defense
function c27084922.initial_effect(c)
    --Negate Attack
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(27084922,0))
  e1:SetCategory(CATEGORY_DESTROY)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_ATTACK_ANNOUNCE)
  e1:SetCost(c27084922.negcost)
  e1:SetCondition(c27084922.negcon1)
  e1:SetTarget(c27084922.negtg1)
  e1:SetOperation(c27084922.negop1)
  c:RegisterEffect(e1)
  --Negate Effect
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(27084922,1))
  e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_ACTIVATE)
  e2:SetCode(EVENT_CHAINING)
  e2:SetCost(c27084922.negcost)
  e2:SetCondition(c27084922.negcon2)
  e2:SetTarget(c27084922.negtg2)
  e2:SetOperation(c27084922.negop2)
  c:RegisterEffect(e2)
end
function c27084922.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xc1c) and c:IsAbleToDeckAsCost()
end
function c27084922.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c27084922.cfilter,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c27084922.cfilter,tp,LOCATION_REMOVED,0,1,1,nil)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c27084922.negconfilter1(c)
  return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc1c)
end
function c27084922.negcon1(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetAttacker():IsControler(1-tp) and Duel.IsExistingMatchingCard(c27084922.negconfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c27084922.negtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return true end
  Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c27084922.negop1(e,tp,eg,ep,ev,re,r,rp)
  local a=Duel.GetAttacker()
  if Duel.NegateAttack(a) then
    Duel.Destroy(a,REASON_EFFECT)
  end
end
function c27084922.negcon2(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsExistingMatchingCard(c27084922.negconfilter1,tp,LOCATION_MZONE,0,1,nil) then return false end
    if tp==ep or not Duel.IsChainNegatable(ev) then return false end
    if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
    local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
    return ex and tg~=nil and tc+tg:FilterCount(c27084922.negconfilter1,nil,tp)-tg:GetCount()>0
end
function c27084922.negtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c27084922.negop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end