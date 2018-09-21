function c26032003.initial_effect(c)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c26032003.spcon)
    c:RegisterEffect(e2)
    --destroy field
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(26032003,0))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_HANDES)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,26032003)
    e2:SetTarget(c26032003.destg)
    e2:SetOperation(c26032003.desop)
    c:RegisterEffect(e2)
end
function c26032003.spfilter(c)
    return c:IsFaceup() and c:IsCode(26032011)
end
function c26032003.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c26032003.spfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c26032003.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g1=Duel.SelectTarget(tp,nil,tp,LOCATION_FZONE,LOCATION_FZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c26032003.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local tcc=tc:GetCode()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        if tcc==(26032009) and Duel.SelectYesNo(tp,aux.Stringid(26032003,1)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
            local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):Select(1-tp,1,1,nil)
            Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
        end
        if tcc==(26032010) and Duel.SelectYesNo(tp,aux.Stringid(26032003,2)) then
            local sg=Duel.GetMatchingGroup(c26032003.sumfilter,tp,0,LOCATION_SZONE,nil)
            Duel.Destroy(sg,REASON_EFFECT)
        end
        if tcc==(26032012) and Duel.SelectYesNo(tp,aux.Stringid(26032003,3)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
            local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,LOCATION_GRAVE):Select(tp,1,5,nil)
            Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        end
    end
end
function c26032003.sumfilter(c)
    return c:GetSequence()<5
end
