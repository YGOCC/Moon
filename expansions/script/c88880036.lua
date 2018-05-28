--Universal-Eyes Divine Lord Mirrorwing Dragon
function c88880036.initial_effect(c)
    --(0)Enable Revive Limit
    c:EnableReviveLimit()
    --(1)level/rank
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_LEVEL_RANK_S)
    c:RegisterEffect(e0)
    --(2)Destroy all monsters
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(27,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(c88880036.destg)
    e1:SetOperation(c88880036.desop)
    c:RegisterEffect(e1)
    --(3)des 1 monster on normal summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(27,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCondition(c88880036.desscon)
    e2:SetTarget(c88880036.desstar)
    e2:SetOperation(c88880036.dessop)
    c:RegisterEffect(e2)
    --(4) Des all monsters when attacked
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(27,2))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BE_BATTLE_TARGET)
    e3:SetTarget(c88880036.destg)
    e3:SetOperation(c88880036.negop)
    c:RegisterEffect(e3)
    --(5) Level change
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_CHANGE_LEVEL)
    e4:SetValue(8)
    c:RegisterEffect(e4)
    local e5=e2:Clone()
    e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e5)
    local e6=e2:Clone()
    e6:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e6)    
end
--(3)des 1 monster
function c88880036.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x107b) and not c:IsCode(88880036)
end
function c88880036.desscon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c88880036.filter,1,nil)
end
function c88880036.desstar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c88880036.dessop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
--(4)des all monsters when attacked
function c88880036.dessscon(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local bc=c:GetBattleTarget()
  e:SetLabelObject(bc)
  return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle()
end
--(2) destroy effect
function c88880036.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
--(4) negate attack and destroy
function c88880036.negop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
    if Duel.NegateAttack() and g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
--(2) destroy all
function c88880036.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end