--"Cyberon Blaster"
--by "Márcio Eduine"
local m=90012
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Fusion Materials"
    c:EnableReviveLimit()
    aux.AddFusionProcCodeFunRep(c,c90012.matfilter0,c90012.matfilter1,1,63,true,true)
    --"Multi Attack"
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e0:SetCode(EVENT_SPSUMMON_SUCCESS)
    e0:SetCondition(c90012.mtcon)
    e0:SetOperation(c90012.mtop)
    c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_MATERIAL_CHECK)
    e1:SetValue(c90012.valcheck)
    e1:SetLabelObject(e0)
    c:RegisterEffect(e1)
    --"ATK Becomes Double"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90012,0))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e2:SetCountLimit(1)
    e2:SetCondition(c90012.atkcon)
    e2:SetCost(c90012.atkcost)
    e2:SetOperation(c90012.atkop)
    c:RegisterEffect(e2)
    --"Destroy"
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BATTLE_DAMAGE)
    e3:SetOperation(c90012.regop)
    c:RegisterEffect(e3)
    --"Special Summon"
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(90012,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetCondition(c90012.spcon)
    e4:SetTarget(c90012.sptg)
    e4:SetOperation(c90012.spop)
    c:RegisterEffect(e4)
end
c90012.material_setcode=0x20aa
function c90012.matfilter0(c)
    return c:IsFusionType(TYPE_PENDULUM) and c:IsFusionSetCard(0x20aa)
end
function c90012.matfilter1(c)
    return c:IsFusionType(TYPE_LINK) and c:IsFusionSetCard(0x20aa)
end
function c90012.mfilter2(c)
    return c:IsFusionType(TYPE_LINK)
end
function c90012.valcheck(e,c)
    local g=c:GetMaterial()
    local ct=g:FilterCount(c90012.mfilter2,nil)
    e:GetLabelObject():SetLabel(ct)
end
function c90012.mtcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()>0
end
function c90012.mtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=e:GetLabel()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EXTRA_ATTACK)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
    e1:SetValue(ct-1)
    c:RegisterEffect(e1)
end
function c90012.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetBattleTarget()~=nil
end
function c90012.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,90000) end
    local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,90000)
    Duel.Release(g,REASON_COST)
end
function c90012.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local atk=c:GetBaseAttack()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_DAMAGE_CAL)
        e1:SetValue(c:GetAttack()*2)
        c:RegisterEffect(e1)
    end
end
function c90012.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsDefensePos() and c==Duel.GetAttackTarget() then
        local e1=Effect.CreateEffect(c)
        e1:SetDescription(aux.Stringid(90012,1))
        e1:SetCategory(CATEGORY_DESTROY)
        e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
        e1:SetCode(EVENT_DAMAGE_STEP_END)
        e1:SetTarget(c90012.destg)
        e1:SetOperation(c90012.desop)
        e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
        c:RegisterEffect(e1)
    end
end
function c90012.desfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c90012.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c90012.desfilter(chkc) end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c90012.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c90012.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function c90012.spcon(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and e:GetHandler():GetPreviousControler()==tp
end
function c90012.spfilter(c,e,tp)
    return not c:IsCode(90012) and c:IsSetCard(0x20aa) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90012.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c90012.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c90012.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c90012.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c90012.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end