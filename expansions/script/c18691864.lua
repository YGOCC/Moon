--Shura, The Midninght Assassin
function c18691864.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x50e),2)
    c:EnableReviveLimit()
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(18691864,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,18691864)
    e1:SetTarget(c18691864.target)
    e1:SetOperation(c18691864.operation)
    c:RegisterEffect(e1)
end
function c18691864.spcheck(g)
    return g:GetClassCount(Card.SetMaterial)==0x50e
end
function c18691864.filter(c,e,tp,zone)
    return (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c18691864.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c18691864.filter(chkc,e,tp,zone) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c18691864.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,zone) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c18691864.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,zone)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c18691864.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    local zone=bit.band(c:GetLinkedZone(tp),0x1f)
    if tc and tc:IsRelateToEffect(e) and zone~=0
        and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone) then
end
end