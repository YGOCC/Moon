--"Copy and Paste"
local m=90604
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Activate"
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --"Special Summon"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90604,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c90604.target)
    e1:SetOperation(c90604.operation)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90604,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c90604.sptg)
    e2:SetOperation(c90604.spop)
    c:RegisterEffect(e2)
    --"Reflect Damage"
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_REFLECT_DAMAGE)
    e3:SetRange(LOCATION_REMOVED)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,0)
    e3:SetValue(c90604.refcon)
    c:RegisterEffect(e3)
end

function c90604.spfilter0(c,e,tp,code)
    return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90604.filter(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(0x1aa) and c:IsType(TYPE_PENDULUM)
        and Duel.IsExistingMatchingCard(c90604.spfilter0,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c90604.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsCode(e:GetLabel()) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c90604.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c90604.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    e:SetLabel(g:GetFirst():GetCode())
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c90604.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local code=tc:GetCode()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c90604.spfilter0,tp,LOCATION_DECK,0,1,1,nil,e,tp,code)
        if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
function c90604.spfilter1(c,e,tp)
    return c:IsSetCard(0x1aa) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90604.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and Duel.IsExistingMatchingCard(c90604.spfilter1,tp,LOCATION_DECK,0,2,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c90604.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
    local g=Duel.GetMatchingGroup(c90604.spfilter1,tp,LOCATION_DECK,0,nil,e,tp)
    if g:GetCount()>=2 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,2,2,nil)
        local tc=sg:GetFirst()
        Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_LEVEL)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(1)
        tc:RegisterEffect(e1)
        tc=sg:GetNext()
        Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
        local e2=e1:Clone()
        tc:RegisterEffect(e2)
        Duel.SpecialSummonComplete()
    end
end
function c90604.refcon(e,re,val,r,rp,rc)
    return bit.band(r,REASON_EFFECT)~=0 and rp==1-e:GetHandler():GetControler()  and e:GetHandler():IsAttackPos()
end