function c26032002.initial_effect(c)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c26032002.spcon)
    c:RegisterEffect(e2)
    --destroy field
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(26032002,0))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,26032002)
    e2:SetTarget(c26032002.destg)
    e2:SetOperation(c26032002.desop)
    c:RegisterEffect(e2)
end
function c26032002.spfilter(c)
    return c:IsFaceup() and c:IsCode(26032010)
end
function c26032002.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c26032002.spfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c26032002.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g1=Duel.SelectTarget(tp,nil,tp,LOCATION_FZONE,LOCATION_FZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c26032002.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local tcc=tc:GetCode()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        if tcc==(26032009) and Duel.SelectYesNo(tp,aux.Stringid(26032002,1)) then
            local g=Duel.SelectMatchingCard(tp,c26032002.sprfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
            local tg=g:GetFirst()
            if tg and Duel.SpecialSummonStep(tg,0,tp,tp,false,false,POS_FACEUP) then
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_CANNOT_TRIGGER)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                tg:RegisterEffect(e1)
            end
            Duel.SpecialSummonComplete()
        end
        if tcc==(26032011) and Duel.SelectYesNo(tp,aux.Stringid(26032002,2)) then
            local c=e:GetHandler()
            local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
            local tc=tg:GetFirst()
            while tc do
                local atk=tc:GetAttack()
                local def=tc:GetDefense()
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_SET_ATTACK_FINAL)
                e1:SetValue(atk/2)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                tc:RegisterEffect(e1)
                local e2=Effect.CreateEffect(c)
                e2:SetType(EFFECT_TYPE_SINGLE)
                e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
                e2:SetValue(def/2)
                e2:SetReset(RESET_EVENT+RESETS_STANDARD)
                tc:RegisterEffect(e2)
                tc=tg:GetNext()
            end
        end
        if tcc==(26032012) and Duel.SelectYesNo(tp,aux.Stringid(26032002,3)) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
            e1:SetCode(EFFECT_CANNOT_ACTIVATE)
            e1:SetTargetRange(0,1)
            e1:SetValue(c26032002.winfilter)
            e1:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_OPPO_TURN)
            Duel.RegisterEffect(e1,tp)
        end
    end
end
function c26032002.sprfilter(c,e,tp)
    return c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26032002.winfilter(e,re,tp)
    return re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP)
end

