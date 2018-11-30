--"Espadachim - Spark Ninja"
local m=70002
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Link Summon"
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c70002.matfilter,2,2)
     --"ATK"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c70002.atkval)
    c:RegisterEffect(e1)
    --"Special Summon"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(70002,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c70002.sptg)
    e2:SetOperation(c70002.spop)
    c:RegisterEffect(e2)
end
function c70002.matfilter(c,lc,sumtype,tp)
    return c:IsLevelBelow(4) and c:IsSetCard(0x509,lc,sumtype,tp)
end
function c70002.atkval(e,c)
    return c:GetLinkedGroupCount()*500
end
function c70002.spfilter(c,e,tp)
    return c:IsLevelBelow(4) and c:IsSetCard(0x509) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c70002.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_HAND) and chkc:IsControler(tp) and c70002.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c70002.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c70002.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c70002.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end