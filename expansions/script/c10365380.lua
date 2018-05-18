--Knight Buster Destruction Sword
function c10365380.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,c10365380.matfilter,1,1)
    c:EnableReviveLimit()
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c10365380.eqtg)
    e1:SetOperation(c10365380.eqop)
    c:RegisterEffect(e1)
    --name change
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_CHANGE_CODE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(78193831)
    c:RegisterEffect(e2)
    --gain
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(10365380,0))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetReset(RESET_EVENT+0x1fe0000)
    e3:SetCountLimit(1,10365380)
    e3:SetCost(c10365380.atcost)
    e3:SetTarget(c10365380.attg)
    e3:SetOperation(c10365380.atop)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e4:SetTarget(c10365380.eftg)
    e4:SetLabelObject(e3)
    c:RegisterEffect(e4)
end
function c10365380.matfilter(c)
    return c:IsLinkSetCard(0xd6) and not c:IsLinkCode(10365380)
end
function c10365380.filter(c)
    return c:IsFaceup() and c:IsSetCard(0xd7)
end
function c10365380.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10365380.filter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c10365380.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c10365380.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c10365380.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    Duel.Equip(tp,c,tc,true)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EQUIP_LIMIT)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    e1:SetValue(c10365380.eqlimit)
    e1:SetLabelObject(tc)
    c:RegisterEffect(e1)
end
function c10365380.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function c10365380.eftg(e,c)
    return e:GetHandler():GetEquipTarget()==c
end
function c10365380.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetEquipGroup():IsExists(Card.IsAbleToGraveAsCost,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=e:GetHandler():GetEquipGroup():FilterSelect(tp,Card.IsAbleToGraveAsCost,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c10365380.attg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
end
function c10365380.atop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFlagEffect(tp,10365380)~=0 then return end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_RACE)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        e1:SetValue(RACE_DRAGON)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
        Duel.RegisterFlagEffect(tp,10365380,RESET_PHASE+PHASE_END,0,1)
    end
end