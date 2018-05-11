--RUM－クイック・カオス
function c88880045.initial_effect(c)
    --(1) Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c88880045.target)
    e1:SetOperation(c88880045.activate)
    c:RegisterEffect(e1)
end
function c88880045.filter1(c,e,tp)
    local m=_G["c"..c:GetCode()]
    return c:IsFaceup() and c:IsSetCard(0x895) and not c:IsSetCard(0x896) and m and (c:GetRank()>0 or c:IsStatus(STATUS_NO_LEVEL)) 
        and Duel.IsExistingMatchingCard(c88880045.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,13)
        and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c88880045.filter2(c,e,tp,mc,rk)
    if c.rum_limit and not c.rum_limit(mc,e) then return false end
    return mc:IsType(TYPE_XYZ,c,SUMMON_TYPE_XYZ,tp) and c:IsRank(rk) and c:IsSetCard(0x896) and mc:IsCanBeXyzMaterial(c,tp) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c88880045.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c88880045.filter1(chkc,e,tp) end
    if chk==0 then return Duel.IsExistingTarget(c88880045.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c88880045.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c88880045.atkval(e,c)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,c:GetControler(),LOCATION_MZONE,0,nil)
    return g:GetSum(Card.GetLevel)*300 + g:GetSum(Card.GetRank)*300
end
function c88880045.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
    local m=_G["c"..tc:GetCode()]
    if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or not m then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c88880045.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,13)
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
        if tc:IsRelateToEffect(e) and tc:IsFaceup() then
            Duel.Equip(tp,c,tc)
            --Atkup
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_EQUIP)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(c88880045.atkval)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            c:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_UPDATE_DEFENSE)
            c:RegisterEffect(e2)
            --Equip limit
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_EQUIP_LIMIT)
            e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e3:SetValue(1)
            e3:SetReset(RESET_EVENT+0x1fe0000)
            c:RegisterEffect(e3)
        end
    end
end