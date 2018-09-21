function c26032004.initial_effect(c)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c26032004.spcon)
    c:RegisterEffect(e2)
    --destroy field
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(26032004,0))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE+CATEGORY_HANDES+CATEGORY_DRAW)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,26032004)
    e2:SetTarget(c26032004.destg)
    e2:SetOperation(c26032004.desop)
    c:RegisterEffect(e2)
end
function c26032004.spfilter(c)
    return c:IsFaceup() and c:IsCode(26032012)
end
function c26032004.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c26032004.spfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c26032004.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g1=Duel.SelectTarget(tp,nil,tp,LOCATION_FZONE,LOCATION_FZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c26032004.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local tcc=tc:GetCode()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        if tcc==(26032009) and Duel.SelectYesNo(tp,aux.Stringid(26032004,1)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local g=Duel.SelectMatchingCard(tp,c26032004.sprfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
            if g:GetCount()>0 then
                Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
            end
        end
        if tcc==(26032010) and Duel.SelectYesNo(tp,aux.Stringid(26032004,2)) then
            local c=e:GetHandler()
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetCode(EFFECT_PIERCE)
            e1:SetRange(LOCATION_MZONE)
            e1:SetTargetRange(LOCATION_MZONE,0)
            e1:SetReset(RESET_PHASE+PHASE_END)
            Duel.RegisterEffect(e1,tp)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
            e2:SetRange(LOCATION_MZONE)
            e2:SetTargetRange(LOCATION_MZONE,0)
            e2:SetCondition(c26032004.sumcon)
            e2:SetOperation(c26032004.sumop)
            e2:SetDescription(aux.Stringid(26032004,3))
            e2:SetReset(RESET_PHASE+PHASE_END)
            Duel.RegisterEffect(e2,tp)
        end
        if tcc==(26032011) and Duel.SelectYesNo(tp,aux.Stringid(26032004,3)) then
            local h1=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
            local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
            Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
            Duel.BreakEffect()
            Duel.Draw(1-tp,h1,REASON_EFFECT)
        end
    end
end
function c26032004.sprfilter(c,e,tp)
    return c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26032004.sumcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return ep~=tp and tc:GetBattleTarget()~=nil and tc:GetBattleTarget():IsDefensePos()
end
function c26032004.sumop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(ep,ev*2)
    Duel.Hint(HINT_CARD,0,26032004)
end
