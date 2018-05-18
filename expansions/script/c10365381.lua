--Destruction Sword’s Future
function c10365381.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,10365381)
    e1:SetTarget(c10365381.target)
    e1:SetOperation(c10365381.activate)
    c:RegisterEffect(e1)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,10465381)
    e2:SetCost(c10365381.thcost)
    e2:SetTarget(c10365381.thtg)
    e2:SetOperation(c10365381.thop)
    c:RegisterEffect(e2)
end
function c10365381.eqtarget(c)
    return c:IsFaceup() and c:IsSetCard(0xd7)
end
function c10365381.eqcard(c,tp)
    return c:IsSetCard(0xd6) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c10365381.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c10365381.eqtarget(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c10365381.eqtarget,tp,LOCATION_MZONE,0,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c10365381.eqcard,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) 
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c10365381.eqtarget,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c10365381.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local ec=Duel.SelectMatchingCard(tp,c10365381.eqcard,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
    if ec then
        Duel.Equip(tp,ec,tc)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(c10365381.eqlimit)
        e1:SetLabelObject(tc)
        ec:RegisterEffect(e1)
    end
end
function c10365381.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function c10365381.cfilter(c)
    return c:IsSetCard(0xd6) and c:IsDiscardable()
end
function c10365381.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c10365381.cfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,c10365381.cfilter,1,1,REASON_DISCARD+REASON_COST)
end
function c10365381.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10365381.thop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
    end
end