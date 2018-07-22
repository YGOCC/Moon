--Magic Synthblade - Long Night
function c39507270.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcCode2(c,39507262,39507264,true,true)
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c39507270.eqtg)
    e1:SetOperation(c39507270.eqop)
    c:RegisterEffect(e1)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_TOHAND)
    e2:SetDescription(aux.Stringid(39507270,2))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(aux.exccon)
    e2:SetTarget(c39507270.tdtg)
    e2:SetOperation(c39507270.tdop)
    c:RegisterEffect(e2)
end
function c39507270.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc~=e:GetHandler() end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function c39507270.eqop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc then return end
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsLocation(LOCATION_SZONE) or c:IsFacedown() then return end
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    Duel.Equip(tp,c,tc)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EQUIP_LIMIT)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetValue(c39507270.eqlimit)
    e1:SetLabelObject(tc)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(500)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    e3:SetValue(500)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_EQUIP)
    e4:SetCode(EFFECT_UPDATE_LEVEL)
    e4:SetValue(2)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_EQUIP)
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetValue(c39507270.efilter)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(39507270,0))
    e6:SetCategory(CATEGORY_REMOVE)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_BATTLE_DESTROYING)
    e4:SetRange(LOCATION_SZONE)
    e6:SetCondition(c39507270.remcon)
    e6:SetTarget(c39507270.remtg)
    e6:SetOperation(c39507270.remop)
    c:RegisterEffect(e6)
end
function c39507270.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function c39507270.efilter(e,re)
    return re:IsActiveType(TYPE_MONSTER) and re:GetOwnerPlayer()~=e:GetHandlerPlayer() and re:GetHandler():GetAttribute()==ATTRIBUTE_DARK
end
function c75702749.remcon(e,tp,eg,ep,ev,re,r,rp)
    local ec=e:GetHandler():GetEquipTarget()
    return ec and eg:IsContains(ec)
end

function c39507270.thfilter(c)
    return c:IsSetCard(0xf6e) and c:IsAbleToHand()
end
function c39507270.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingMatchingCard(c39507270.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c39507270.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_EXTRA) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c39507270.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
end
