--Fantasia Knight Golem
function c71473111.initial_effect(c)
    --Xyz Summon
    c:EnableReviveLimit()
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1C1D),4,2)
    --Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(71473111,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c71473111.cost)
    e1:SetTarget(c71473111.target)
    e1:SetOperation(c71473111.operation)
    c:RegisterEffect(e1)
    --Destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(71473111,1))
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c71473111.cost)
    e2:SetTarget(c71473111.destg)
    e2:SetOperation(c71473111.desop)
    c:RegisterEffect(e2)
end
function c71473111.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c71473111.filter(c,e,tp)
    return (c:IsFaceup() or c:IsType(TYPE_MONSTER)) and c:GetLevel()==3 and c:IsSetCard(0x1C1D) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71473111.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local loc=0
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND+LOCATION_PZONE end
    if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
    if chk==0 then return loc~=0 and Duel.IsExistingTarget(c71473111.filter,tp,loc,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c71473111.filter,tp,loc,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,loc)
end
function c71473111.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or (tc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp)<=0) then return end
    if tc:IsLocation(LOCATION_EXTRA) and tc:IsRelateToEffect(e) then 
        Duel.SpecialSummon(tc,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
    else
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c71473111.desfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x1C1D) and c:IsDestructable()
end
function c71473111.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c71473111.desfilter,tp,LOCATION_HAND+LOCATION_PZONE+LOCATION_MZONE,0,1,e:GetHandler()) end
    local g=Duel.GetMatchingGroup(c71473111.desfilter,tp,LOCATION_HAND+LOCATION_PZONE+LOCATION_MZONE,0,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c71473111.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c71473111.desfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_PZONE,0,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local dg=g:Select(tp,1,#g,nil)
    if dg:GetCount()>0 then
        local ct=Duel.Destroy(dg,REASON_EFFECT)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
        e1:SetValue(ct*300)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        c:RegisterEffect(e1)
    end
end
