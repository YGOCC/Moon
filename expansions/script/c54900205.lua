--Re-Creation Dragon
function c54900205.initial_effect(c)
    --Level to 1
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(54900205,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c54900205.sptg)
    e1:SetOperation(c54900205.spop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --Special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(54900205,1))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetTarget(c54900205.sptg)
    e3:SetOperation(c54900205.spop)
    c:RegisterEffect(e3)
    --Extra Limit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(1,0)
    e4:SetTarget(c54900205.sumlimit)
    c:RegisterEffect(e4)
    --Gain ATK and DEF
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetCost(c54900205.atkcost)
    e5:SetTarget(c54900205.atktg)
    e5:SetOperation(c54900205.atkop)
    c:RegisterEffect(e5)
end
function c54900205.sumlimit(e,c)
    return not c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_XYZ)
end
function c54900205.lvfilter(c)
    return c:IsFaceup() and c:IsLevelAbove(2)
end
function c54900205.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c54900205.lvfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
end
function c54900205.spfilter(c,e,tp)
    return c:IsLocation(LOCATION_DECK) and c:IsSetCard(0xCF11) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c54900205.lvop(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetMatchingGroup(c54900205.lvfilter,tp,LOCATION_MZONE,0,e:GetHandler())
    local tc=g1:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:ReagisterEffect(e1)
        tc=g1:GetNext()
    end
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g2=Duel.SelectMatchingCard(tp,c54900205.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
        local tc=g2:GetFirst()
        if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetValue(0)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            tc:RegisterEffect(e1,true)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
            tc:RegisterEffect(e2,true)
            Duel.SpecialSummonComplete()
    end
end
function c54900205.filter(c,e,tp)
    return c:IsSetCard(0xCF11) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c54900205.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c54900205.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c54900205.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c54900205.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c54900205.cfilter(c,tp)
    local lv=c:GetLevel()
    return lv>0 and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
        and Duel.IsExistingTarget(c54900205.atkfilter,tp,LOCATION_MZONE,0,1,nil,lv)
end
function c54900205.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c54900205.cfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c54900205.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    e:SetLabel(g:GetFirst():GetLevel())
end
function c54900205.atkfilter(c,lv)
    local clv=c:GetLevel()
    return c:IsFaceup() and clv>0 and clv~=lv and c:IsType(TYPE_MONSTER)
end
function c54900205.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c54900205.atkfilter(chkc,e:GetLabel()) end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c54900205.atkfilter,tp,LOCATION_MZONE,0,1,1,nil,e:GetLabel())
end
function c54900205.atkop(e,tp,eg,ep,ev,re,r,rp)
    local lv=e:GetLabel()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetLevel()~=lv then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(lv*100)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        e2:SetValue(lv*100)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2)
    end
end