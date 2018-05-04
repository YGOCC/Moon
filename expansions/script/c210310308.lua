-- Cloudian Superiority
local id= 210310308
local ref=_G['c'..id]
local s=0x18

function ref.initial_effect(c)
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_ACTIVATE)
  e0:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e0)
  -- Unaffected
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_IMMUNE_EFFECT)
  e1:SetRange(LOCATION_FZONE)
  e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e1:SetCondition(ref.immcon)
  e1:SetTargetRange(LOCATION_MZONE,0)
  e1:SetTarget(aux.TargetBoolFunction(ref.f))
  e1:SetValue(ref.tv)
  c:RegisterEffect(e1)
  -- ATK
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetRange(LOCATION_FZONE)
  e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
  e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,s))
  e2:SetValue(500)
  c:RegisterEffect(e2)
  -- Cannot Destroy
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_FIELD)
  e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
  e3:SetRange(LOCATION_FZONE)
  e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
  e3:SetValue(1)
  e3:SetCondition(ref.c)
  e3:SetTarget(ref.t)
  c:RegisterEffect(e3)
end

-- Unaffected
function ref.immcon(e)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,nil,0xe1)
end
function ref.tv(e,re,rp)
  
  return rp~=e:GetHandlerPlayer() and not re:IsHasCategory(CATEGORY_POSITION)
end

-- Cannot Destroy
function ref.f(c)
  return c:IsFaceup() and c:IsSetCard(s)
end
function ref.c(e,tp,eg,ep,ev,re,r,rp)
  local hasCard=Duel.IsExistingMatchingCard(ref.f,tp,LOCATION_MZONE,0,1,nil)

  return hasCard 
end

function ref.t(e,c)
  local t=c:GetType()
  local f=function (chk)
    return (bit.band(t,chk)==chk)
  end
  local isContinuousSpell=f(TYPE_SPELL+TYPE_CONTINUOUS)
  local isContinuousTrap=f(TYPE_TRAP+TYPE_CONTINUOUS)

  return isContinuousSpell or isContinuousTrap
end