function c26032001.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c26032001.spcon)
    c:RegisterEffect(e1)
    --destroy field
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(26032001,0))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,26032001)
    e2:SetTarget(c26032001.destg)
    e2:SetOperation(c26032001.desop)
    c:RegisterEffect(e2)
end
function c26032001.spfilter(c)
    return c:IsFaceup() and c:IsCode(26032009)
end
function c26032001.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c26032001.spfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c26032001.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g1=Duel.SelectTarget(tp,nil,tp,LOCATION_FZONE,LOCATION_FZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c26032001.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local tcc=tc:GetCode()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        if tcc==(26032010) and Duel.SelectYesNo(tp,aux.Stringid(26032001,1)) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
            e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
            e1:SetTargetRange(1,0)
            e1:SetValue(2)
            e1:SetReset(RESET_PHASE+PHASE_END)
            Duel.RegisterEffect(e1,tp)
        end
        if tcc==(26032011) and Duel.SelectYesNo(tp,aux.Stringid(26032001,2)) then
            if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil)~=0 then
                Duel.BreakEffect()
                Duel.Draw(tp,2,REASON_EFFECT)
            end
        end
        if tcc==(26032012) and Duel.SelectYesNo(tp,aux.Stringid(26032001,3)) then
            local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,4,nil)
            if g:GetCount()>0 then
                Duel.HintSelection(g)
                Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
            end
        end
    end
end
function c26032001.sumfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end



