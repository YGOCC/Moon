--"Hacker's Ritual"
local m=90079
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Activate"
    local e0=Effect.CreateEffect(c)
    e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetCountLimit(1,90079+EFFECT_COUNT_CODE_OATH)
    e0:SetTarget(c90079.target)
    e0:SetOperation(c90079.operation)
    c:RegisterEffect(e0)
    --"To Hand"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90070,0))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCondition(c90079.thcon)
    e1:SetTarget(c90079.thtg)
    e1:SetOperation(c90079.thop)
    c:RegisterEffect(e1)
end
function c90079.exfilter0(c)
    return c:IsSetCard(0x1aa) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function c90079.filter(c,e,tp,m,ft)
    if not c:IsSetCard(0x1aa) or bit.band(c:GetType(),0x81)~=0x81
        or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
    if c.mat_filter then
        mg=mg:Filter(c.mat_filter,nil)
    end
    if ft>0 then
        return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
    else
        return mg:IsExists(c90079.mfilterf,1,nil,tp,mg,c)
    end
end
function c90079.mfilterf(c,tp,mg,rc)
    if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
        Duel.SetSelectedCard(c)
        return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
    else return false end
end
function c90079.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsSetCard,nil,0x1aa)
        if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>1 then
            local sg=Duel.GetMatchingGroup(c90079.exfilter0,tp,LOCATION_DECK,0,nil)
            mg:Merge(sg)
        end
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        return ft>-1 and Duel.IsExistingMatchingCard(c90079.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg,ft)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c90079.operation(e,tp,eg,ep,ev,re,r,rp)
    local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsSetCard,nil,0x1aa)
    if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>1 then
        local sg=Duel.GetMatchingGroup(c90079.exfilter0,tp,LOCATION_DECK,0,nil)
        mg:Merge(sg)
    end
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c90079.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg,ft)
    local tc=tg:GetFirst()
    if tc then
        mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
        if tc.mat_filter then
            mg=mg:Filter(tc.mat_filter,nil)
        end
        local mat=nil
        if ft>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
        else
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            mat=mg:FilterSelect(tp,c90079.mfilterf,1,1,nil,tp,mg,tc)
            Duel.SetSelectedCard(mat)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
            mat:Merge(mat2)
        end
        tc:SetMaterial(mat)
        local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
        mat:Sub(mat2)
        Duel.ReleaseRitualMaterial(mat)
        Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
function c90079.thfilter(c)
    return c:IsPreviousLocation(LOCATION_HAND)
end
function c90079.thcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c90079.thfilter,1,nil) and re and re:GetHandler():GetCode()~=90079
end
function c90079.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c90079.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SendtoHand(c,nil,REASON_EFFECT)
end