--"Espadachim - Incandescent Demon"
local m=70010
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Link Summon"
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x509),4,4)
    c:EnableReviveLimit()
    --"Search"
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(70010,0))
    e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e0:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e0:SetCode(EVENT_SPSUMMON_SUCCESS)
    e0:SetTarget(c70010.tg)
    e0:SetOperation(c70010.op)
    c:RegisterEffect(e0)
    --"Race"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CHANGE_RACE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(RACE_FIEND)
    c:RegisterEffect(e1)
    --"Equip"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetDescription(aux.Stringid(70010,1))
    e2:SetCategory(CATEGORY_EQUIP)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c70010.eqtg)
    e2:SetOperation(c70010.eqop)
    c:RegisterEffect(e2)
    --"Destroy"
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(70010,2))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_EQUIP)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetTarget(c70010.destg)
    e3:SetOperation(c70010.desop)
    c:RegisterEffect(e3)
    --"Inflict Damage"
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(70010,3))
    e4:SetCategory(CATEGORY_DAMAGE)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCost(c70010.damcost)
    e4:SetTarget(c70010.damtarget)
    e4:SetOperation(c70010.damoperation)
    c:RegisterEffect(e4)
end
function c70010.filter(c)
    return c:IsSetCard(0x510) and c:IsAbleToHand()
end
function c70010.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c70010.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c70010.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c70010.filter),tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c70010.eqfilter(c)
    return c:IsSetCard(0x510) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c70010.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c70010.eqfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function c70010.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c70010.eqfilter),tp,LOCATION_GRAVE,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        if not Duel.Equip(tp,tc,c,true) then return end
        local e1=Effect.CreateEffect(c)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c70010.eqlimit)
        tc:RegisterEffect(e1)
    end
end
function c70010.eqlimit(e,c)
    return e:GetOwner()==c
end
function c70010.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c70010.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function c70010.damfilter(c,ec)
    return c:GetEquipTarget()==ec and c:IsAbleToGraveAsCost()
end
function c70010.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c70010.damfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c70010.damfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e:GetHandler())
    Duel.SendtoGrave(g,REASON_COST)
end
function c70010.damtarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(800)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c70010.damoperation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end