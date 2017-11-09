--Wyndbreaker Laura the Knight
function c97671902.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c97671902.splimit)
    c:RegisterEffect(e1)
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c97671902.spcon)
    e2:SetOperation(c97671902.spop)
    c:RegisterEffect(e2)
    --multiatk
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(97671902,0))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c97671902.atkcon)
    e3:SetCost(c97671902.atkcost)
    e3:SetTarget(c97671902.atktg)
    e3:SetOperation(c97671902.atkop)
    c:RegisterEffect(e3)
    --special summon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(97671902,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetCountLimit(1,97671902)
    e4:SetCondition(c97671902.spcon1)
    e4:SetTarget(c97671902.sptg1)
    e4:SetOperation(c97671902.spop1)
    c:RegisterEffect(e4)  
end
function c97671902.splimit(e,se,sp,st)
    return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end 
function c97671902.rfilter(c,fc)
    return (c:IsFusionSetCard(0xd70) or c:IsFusionSetCard(0xd71))
       and c:IsCanBeFusionMaterial(fc)
end
function c97671902.spfilter1(c,tp,g)
    return g:IsExists(c97671902.spfilter2,1,c,tp,c)
end
function c97671902.spfilter2(c,tp,mc)
    return (c:IsFusionSetCard(0xd70) and mc:IsFusionSetCard(0xd71)
        or c:IsFusionSetCard(0xd71) and mc:IsFusionSetCard(0xd70))
        and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c97671902.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local rg=Duel.GetReleaseGroup(tp):Filter(c97671902.rfilter,nil,c)
    return rg:IsExists(c97671902.spfilter1,1,nil,tp,rg)
end
function c97671902.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local rg=Duel.GetReleaseGroup(tp):Filter(c97671902.rfilter,nil,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=rg:FilterSelect(tp,c97671902.spfilter1,1,1,nil,tp,rg)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=rg:FilterSelect(tp,c97671902.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c97671902.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsAbleToEnterBP()
end
function c97671902.filter(c)
    return c:IsPosition(POS_FACEUP+POS_FACEDOWN) and c:IsSetCard(0xd70)
end
function c97671902.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c97671902.filter,1,e:GetHandler()) end
    local g=Duel.SelectReleaseGroup(tp,c97671902.filter,1,1,e:GetHandler())
    Duel.Release(g,REASON_COST)
end
function c97671902.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c97671902.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_EXTRA_ATTACK)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end
function c97671902.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and e:GetHandler():GetPreviousControler()==tp
end
function c97671902.spfilter(c,e,tp)
    return c:IsSetCard(0xd70) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c97671902.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c97671902.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c97671902.spop1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c97671902.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
    end
end