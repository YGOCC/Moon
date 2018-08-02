--ASSASSIN - Lucy The Devil Thief
function c18691860.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x50e),1,99,c18691860.lcheck)
    c:EnableReviveLimit()
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(18691860,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(2)
    e1:SetCondition(c18691860.condition)
    e1:SetTarget(c18691860.sptg)
    e1:SetOperation(c18691860.spop)
    c:RegisterEffect(e1)
    --control
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(18691860,1))
    e2:SetCategory(CATEGORY_CONTROL)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(2)
    e2:SetCondition(c18691860.condition)
    e2:SetTarget(c18691860.cttg)
    e2:SetOperation(c18691860.ctop)
    c:RegisterEffect(e2)
    --Race change
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(18691860,0))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c18691860.atttg)
    e3:SetOperation(c18691860.attop)
    c:RegisterEffect(e3)
end
function c18691860.lcheck(g,lc)
    return g:IsExists(Card.IsCode,1,nil,18691861)
end
function c18691860.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>=0
end
function c18691860.spfilter(c,e,tp,zone)
    return c:IsLevelBelow(4) and c:IsSetCard(0x50e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c18691860.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local zone=e:GetHandler():GetLinkedZone(tp)
        return zone~=0 and Duel.IsExistingMatchingCard(c18691860.spfilter,tp,LOCATION_HAND+LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp,zone)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED+LOCATION_GRAVE)
end
function c18691860.spop(e,tp,eg,ep,ev,re,r,rp)
    local zone=e:GetHandler():GetLinkedZone(tp)
    if zone==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c18691860.spfilter,tp,LOCATION_HAND+LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
    end
end
function c18691860.ctfilter(c)
    return c:IsOnField() and c:IsControlerCanBeChanged()
end
function c18691860.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c18691860.ctfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c18691860.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,c18691860.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c18691860.ctop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.GetControl(tc,tp,PHASE_END,1)
    end
end
function c18691860.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
    local aat=Duel.AnnounceRace(tp,1,RACE_ALL-e:GetHandler():GetRace())
    e:SetLabel(aat)
end
function c18691860.attop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_RACE)
        e1:SetValue(e:GetLabel())
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end
