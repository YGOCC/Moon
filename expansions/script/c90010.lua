--"Cyberon Storm"
--by "Márcio Eduine"
local m=90010
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    --"Destroy"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90010,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c90010.descon)
    e1:SetTarget(c90010.destg)
    e1:SetOperation(c90010.desop)
    c:RegisterEffect(e1)
    --"Target"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,LOCATION_MZONE)
    e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e2:SetCondition(c90010.atcon)
    e2:SetValue(c90010.atlimit)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetCondition(c90010.atcon)
    e3:SetTarget(c90010.tglimit)
    e3:SetValue(aux.tgoval)
    c:RegisterEffect(e3)
    --"Destroy"
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(90010,0))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_BATTLE_START)
    e4:SetCondition(c90010.descon1)
    e4:SetTarget(c90010.destg1)
    e4:SetOperation(c90010.desop1)
    c:RegisterEffect(e4)
end
function c90010.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c90010.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSummonType,tp,0,LOCATION_MZONE,1,nil,SUMMON_TYPE_SPECIAL) end
    local g=Duel.GetMatchingGroup(Card.IsSummonType,tp,0,LOCATION_MZONE,1,nil,SUMMON_TYPE_SPECIAL)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c90010.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(Card.IsSummonType,tp,0,LOCATION_MZONE,nil,SUMMON_TYPE_SPECIAL)
    local ct=Duel.Destroy(g,REASON_EFFECT)
    if ct>0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(ct*100)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
        c:RegisterEffect(e1)
    end
end
function c90010.filter(c)
    return c:IsSetCard(0x20aa) and c:IsType(TYPE_PENDULUM)
end
function c90010.atcon(e)
    return Duel.IsExistingMatchingCard(c90010.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c90010.atlimit(e,c)
    return c~=e:GetHandler()
end
function c90010.tglimit(e,c)
    return c~=e:GetHandler()
end
function c90010.descon1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c90010.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c90010.desop1(e,tp,eg,ep,ev,re,r,rp)
    local bc=e:GetHandler():GetBattleTarget()
    if bc:IsRelateToBattle() then
        Duel.Destroy(bc,REASON_EFFECT)
    end
end