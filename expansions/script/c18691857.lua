--LAND OF ASSASSIN
function c18691857.initial_effect(c)
   --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e3:SetRange(LOCATION_SZONE)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(c18691857.target)
    e3:SetValue(c18691857.indct)
    c:RegisterEffect(e3)
    --move
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(18691857,0))
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c18691857.seqtg)
    e3:SetOperation(c18691857.seqop)
    c:RegisterEffect(e3)
    --change
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(18691857,1))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(c18691857.chtg)
    e4:SetOperation(c18691857.chop)
    c:RegisterEffect(e4)
end
function c18691857.target(e,c)
    return c:IsSetCard(0x50e)
end
function c18691857.indct(e,re,r,rp)
    if bit.band(r,REASON_BATTLE)~=0 then
        return 1
    else return 0 end
end
function c18691857.filter(c)
    if not c:IsType(TYPE_LINK) then return false end
    local p=c:GetControler()
    local zone=bit.band(c:GetLinkedZone(),0x1f)
    return Duel.GetLocationCount(p,LOCATION_MZONE,p,LOCATION_REASON_CONTROL,zone)>0
end
function c18691857.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c18691857.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c18691857.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(18691857,2))
    Duel.SelectTarget(tp,c18691857.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c18691857.seqop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
    local p=tc:GetControler()
    local zone=bit.band(tc:GetLinkedZone(),0x1f)
    if Duel.GetLocationCount(p,LOCATION_MZONE,p,LOCATION_REASON_CONTROL,zone)>0 then
        local s=0
        if tc:IsControler(tp) then
            local flag=bit.bxor(zone,0xff)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
            s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
        else
            local flag=bit.bxor(zone,0xff)*0x10000
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
            s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,flag)/0x10000
        end
        local nseq=0
        if s==1 then nseq=0
        elseif s==2 then nseq=1
        elseif s==4 then nseq=2
        elseif s==8 then nseq=3
        else nseq=4 end
        Duel.MoveSequence(tc,nseq)
    end
end
function c18691857.chfilter1(c)
    return c:IsType(TYPE_LINK) and c:GetSequence()<5
        and Duel.IsExistingMatchingCard(c18691857.chfilter2,c:GetControler(),LOCATION_MZONE,0,1,c)
end
function c18691857.chfilter2(c)
    return c:IsType(TYPE_LINK) and c:GetSequence()<5
end
function c18691857.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c18691857.chfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c18691857.chop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g1=Duel.SelectMatchingCard(tp,c18691857.chfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    local tc1=g1:GetFirst()
    if not tc1 then return end
    Duel.HintSelection(g1)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g2=Duel.SelectMatchingCard(tp,c18691857.chfilter2,tc1:GetControler(),LOCATION_MZONE,0,1,1,tc1)
    Duel.HintSelection(g2)
    local tc2=g2:GetFirst()
    Duel.SwapSequence(tc1,tc2)
end
