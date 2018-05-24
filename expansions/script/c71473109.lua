--Fantasia Knight Blacksmith
function c71473109.initial_effect(c)
    --Xyz Summon
    c:EnableReviveLimit()
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1C1D),3,2)
    --Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(71473109,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c71473109.cost1)
    e1:SetTarget(c71473109.target1)
    e1:SetOperation(c71473109.operation1)
    c:RegisterEffect(e1)
    --Set
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(71473109,1))
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c71473109.cost2)
    e2:SetTarget(c71473109.target2)
    e2:SetOperation(c71473109.operation2)
    c:RegisterEffect(e2)
end
function c71473109.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c71473109.filter1(c,e,tp)
    return c:IsFaceup() or c:IsType(TYPE_MONSTER) and c:GetLevel()==4 and c:IsSetCard(0x1C1D) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71473109.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        local loc=0
        if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND+LOCATION_PZONE end
        if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
        return loc~=0 and Duel.IsExistingTarget(c71473109.filter1,tp,loc,0,1,nil,e,tp)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c71473109.filter1,tp,loc,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,loc)
end
function c71473109.operation1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or (tc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp)<=0) then return end
    if tc:IsLocation(LOCATION_EXTRA) and tc:IsRelateToEffect(e) then 
        Duel.SpecialSummon(tc,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
    else
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c71473109.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) 
        and Duel.CheckLPCost(tp,1000) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
    Duel.PayLPCost(tp,1000)
end
function c71473109.filter2(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x1C1D)
end
function c71473109.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c71473109.filter2,tp,LOCATION_EXTRA,0,1,nil) end
end
function c71473109.operation2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c71473109.filter2,tp,LOCATION_EXTRA,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
    