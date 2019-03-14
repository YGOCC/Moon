--"Cyberon Holy Detonator"
--by "Márcio Eduine"
local m=90014
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Fusion Materials"
    c:EnableReviveLimit()
    aux.AddFusionProcCodeFunRep(c,c90014.matfilter0,c90014.matfilter1,1,63,true,true)
    --"Gain ATK"
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetCode(EVENT_SPSUMMON_SUCCESS)
    e0:SetCondition(c90014.atkcon)
    e0:SetOperation(c90014.atkop)
    c:RegisterEffect(e0)
    --"Destroy"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(42717221,0))
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,90014)
    e1:SetCost(c90014.dcost)
    e1:SetTarget(c90014.dtg)
    e1:SetOperation(c90014.dop)
    c:RegisterEffect(e1)
    --"ATK"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90014,1))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_DAMAGE)
    e2:SetCondition(c90014.atkcon1)
    e2:SetOperation(c90014.atkop1)
    c:RegisterEffect(e2)
    --"Special Summon"
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(90014,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCondition(c90014.spcon)
    e3:SetTarget(c90014.sptg)
    e3:SetOperation(c90014.spop)
    c:RegisterEffect(e3)
end
c90014.material_setcode=0x20aa
function c90014.matfilter0(c)
    return c:IsFusionType(TYPE_PENDULUM) and c:IsFusionSetCard(0x20aa)
end
function c90014.matfilter1(c)
    return c:IsFusionType(TYPE_LINK) and c:IsFusionSetCard(0x20aa)
end
function c90014.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c90014.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=c:GetMaterial()
    local atk=0
    local tc=g:GetFirst()
    while tc do
        local lk=tc:GetLink()
        atk=atk+lk
        tc=g:GetNext()
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(atk*500)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
    c:RegisterEffect(e1)
end
function c90014.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,90000) end
    local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,90000)
    Duel.Release(g,REASON_COST)
    if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e1)
end
function c90014.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,g:GetCount()*300)
end
function c90014.dop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    local ct=Duel.Destroy(g,REASON_EFFECT)
    Duel.Damage(tp,ct*300,REASON_EFFECT)
end
function c90014.atkcon1(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp and bit.band(r,REASON_EFFECT)~=0
end
function c90014.atkop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(ev)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
        c:RegisterEffect(e1)
    end
end
function c90014.spcon(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and e:GetHandler():GetPreviousControler()==tp
end
function c90014.spfilter(c,e,tp)
    return not c:IsCode(90014) and c:IsSetCard(0x20aa) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90014.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c90014.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c90014.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c90014.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c90014.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end