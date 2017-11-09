--Wyndbreaker Isabella the Archer
function c97671904.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c97671904.splimit)
    c:RegisterEffect(e1)
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c97671904.spcon)
    e2:SetOperation(c97671904.spop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetTarget(c97671904.thtg)
    e3:SetOperation(c97671904.thop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_PHASE+PHASE_BATTLE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCondition(c97671904.poscon)
    e5:SetOperation(c97671904.posop)
    c:RegisterEffect(e5)
    --special summon
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(97671904,1))
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e6:SetCode(EVENT_DESTROYED)
    e6:SetCountLimit(1,97671904)
    e6:SetCondition(c97671904.spcon1)
    e6:SetTarget(c97671904.sptg1)
    e6:SetOperation(c97671904.spop1)
    c:RegisterEffect(e6)  
end
function c97671904.splimit(e,se,sp,st)
    return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end 
function c97671904.rfilter(c,fc)
    return (c:IsFusionSetCard(0xd70) or c:IsFusionSetCard(0xd71))
       and c:IsCanBeFusionMaterial(fc)
end
function c97671904.spfilter1(c,tp,g)
    return g:IsExists(c97671904.spfilter2,1,c,tp,c)
end
function c97671904.spfilter2(c,tp,mc)
    return (c:IsFusionSetCard(0xd70) and mc:IsFusionSetCard(0xd71)
        or c:IsFusionSetCard(0xd71) and mc:IsFusionSetCard(0xd70))
        and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c97671904.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local rg=Duel.GetReleaseGroup(tp):Filter(c97671904.rfilter,nil,c)
    return rg:IsExists(c97671904.spfilter1,1,nil,tp,rg)
end
function c97671904.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local rg=Duel.GetReleaseGroup(tp):Filter(c97671904.rfilter,nil,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=rg:FilterSelect(tp,c97671904.spfilter1,1,1,nil,tp,rg)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=rg:FilterSelect(tp,c97671904.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c97671904.thfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd70) and c:IsAbleToHand()
end
function c97671904.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()==tp and c97671904.thfilter(chkc) end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c97671904.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c97671904.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end
end
function c97671904.poscon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetAttackedCount()>0
end
function c97671904.posop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsAttackPos() then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    end
end
function c97671904.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp and e:GetHandler():GetPreviousControler()==tp
end
function c97671904.spfilter(c,e,tp)
    return c:IsSetCard(0xd70) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c97671904.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c97671904.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c97671904.spop1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c97671904.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
    end
end