--"Rank-Up Assassin Force"
local m=18591830
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Activate"
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c18591830.target)
    e1:SetOperation(c18591830.activate)
    c:RegisterEffect(e1)
    --"To Hand"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(18591830,0))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_PREDRAW)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(c18591830.thcon)
    e2:SetTarget(c18591830.thtg)
    e2:SetOperation(c18591830.thop)
    c:RegisterEffect(e2)
end
function c18591830.filter1(c,e,tp)
    return c:IsFaceup() and c:IsType(TYPE_XYZ)
        and Duel.IsExistingMatchingCard(c18591830.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+1)
        and Duel.GetLocationCountFromEx(tp,tp,c)>0
        and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c18591830.filter2(c,e,tp,mc,rk)
    if c:GetOriginalCode()==6165656 and not mc:IsCode(48995978) then return false end
    return c:IsRank(rk) and mc:IsCanBeXyzMaterial(c)
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c18591830.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c18591830.filter1(chkc,e,tp) end
    if chk==0 then return Duel.IsExistingTarget(c18591830.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c18591830.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c18591830.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 or not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
    if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c18591830.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
    local sc=g:GetFirst()
    if sc then
        local mg=tc:GetOverlayGroup()
        if mg:GetCount()~=0 then
            Duel.Overlay(sc,mg)
        end
        sc:SetMaterial(Group.FromCards(tc))
        Duel.Overlay(sc,Group.FromCards(tc))
        Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
        sc:CompleteProcedure()
    end
end
function c18591830.thcon(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
        and Duel.GetDrawCount(tp)>0
end
function c18591830.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    local dt=Duel.GetDrawCount(tp)
    if dt~=0 then
        _replace_count=0
        _replace_max=dt
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c18591830.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    _replace_count=_replace_count+1
    if _replace_count<=_replace_max and c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c)
    end
end