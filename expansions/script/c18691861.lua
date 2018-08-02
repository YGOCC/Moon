--ASSASSIN - LUCY THE THIEF
function c18691861.initial_effect(c)
    --Link summon
    aux.AddLinkProcedure(c,c18691861.matfilter,1)
    c:EnableReviveLimit()
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(18691861,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c18691861.condition)
    e1:SetTarget(c18691861.sptg)
    e1:SetOperation(c18691861.spop)
    c:RegisterEffect(e1)
    --control
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(18691861,1))
    e2:SetCategory(CATEGORY_CONTROL)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c18691861.condition)
    e2:SetTarget(c18691861.cttg)
    e2:SetOperation(c18691861.ctop)
    c:RegisterEffect(e2)
end
function c18691861.matfilter(c)
    return c:IsSetCard(0x50e) and c:IsLevelBelow(4)
end
function c18691861.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>=0
end
function c18691861.spfilter(c,e,tp,zone)
    return c:IsLevelBelow(4) and c:IsSetCard(0x50e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c18691861.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local zone=e:GetHandler():GetLinkedZone(tp)
        return zone~=0 and Duel.IsExistingMatchingCard(c18691861.spfilter,tp,LOCATION_HAND+LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp,zone)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED+LOCATION_GRAVE)
end
function c18691861.spop(e,tp,eg,ep,ev,re,r,rp)
    local zone=e:GetHandler():GetLinkedZone(tp)
    if zone==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c18691861.spfilter,tp,LOCATION_HAND+LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
    end
end
function c18691861.ctfilter(c)
    return c:IsOnField() and c:IsControlerCanBeChanged()
end
function c18691861.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c18691861.ctfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c18691861.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,c18691861.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c18691861.ctop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.GetControl(tc,tp,PHASE_END,1)
    end
end