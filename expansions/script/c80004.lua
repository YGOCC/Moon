--"Espada Demoníaca - Bello Come Un Fiore"
local m=80004
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Activate"
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(80004,0))
    e0:SetCategory(CATEGORY_EQUIP)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e0:SetTarget(c80004.eqtg)
    e0:SetOperation(c80004.eqop)
    c:RegisterEffect(e0)
    --"Atk UP"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_EQUIP)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(300)
    c:RegisterEffect(e1)
    --"Equip Limit"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EQUIP_LIMIT)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetValue(c80004.eqlimit)
    c:RegisterEffect(e2)
    --"Search"
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(80004,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,80004)
    e3:SetCost(c80004.scost)
    e3:SetTarget(c80004.starget)
    e3:SetOperation(c80004.soperation)
    c:RegisterEffect(e3)
    --"Special Summon"
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(80004,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCountLimit(1,80004)
    e4:SetCondition(c80004.spcon)
    e4:SetTarget(c80004.sptg)
    e4:SetOperation(c80004.spop)
    c:RegisterEffect(e4)
    --"ATK DOWN"
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(80004,3))
    e5:SetCategory(CATEGORY_ATKCHANGE)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCountLimit(1)
    e5:SetCost(c80004.atkcost)
    e5:SetTarget(c80004.atktg)
    e5:SetOperation(c80004.atkop)
    c:RegisterEffect(e5)
end
function c80004.eqfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x509)
end
function c80004.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c80004.eqfilter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c80004.eqfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c80004.eqfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c80004.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    Duel.Equip(tp,c,tc,true)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_EQUIP_LIMIT)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e0:SetReset(RESET_EVENT+RESETS_STANDARD)
    e0:SetValue(c80004.eqlimit)
    e0:SetLabelObject(tc)
    c:RegisterEffect(e0)
    --"Direct Attack"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_EQUIP)
    e1:SetCode(EFFECT_DIRECT_ATTACK)
    e1:SetCondition(c80004.dircon)
    c:RegisterEffect(e1)
end
function c80004.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function c80004.dircon(e)
    return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)<=1
end
function c80004.scost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c80004.sfilter(c)
    return c:IsSetCard(0x510) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c80004.starget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
     if chk==0 then return Duel.IsExistingMatchingCard(c80004.sfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
        e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
end
function c80004.soperation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c80004.sfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c80004.costfilter(c)
    return c:IsSetCard(0x509) and c:IsAbleToRemoveAsCost()
end
function c80004.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c80004.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c80004.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c80004.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c80004.atkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_ATTACK_FINAL)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    e1:SetValue(tc:GetAttack()/2)
    tc:RegisterEffect(e1)
end
function c80004.spcon(e,tp,eg,ep,ev,re,r,rp)
     local c=eg:GetFirst()
    return c:IsOnField()
end
function c80004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(80004)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,80004,0x510,0x11,500,500,2,RACE_PLANT,ATTRIBUTE_DARK) end
    c:RegisterFlagEffect(80004,RESET_CHAIN,0,1)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c80004.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,80004,0x510,0x11,500,500,2,RACE_PLANT,ATTRIBUTE_DARK) then
        c:AddMonsterAttribute(TYPE_EFFECT)
        Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
        c:AddMonsterAttributeComplete()
        --"Cannot Attack"
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_ATTACK)
        c:RegisterEffect(e1,true)
        --"Cannot Be Destroyed"
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e2:SetRange(LOCATION_MZONE)
        e2:SetTargetRange(LOCATION_MZONE,0)
        e2:SetTarget(c80004.efilter)
        e2:SetValue(1)
        c:RegisterEffect(e2,true)
        Duel.SpecialSummonComplete()
    end
end
function c80004.efilter(e,c)
    return (c:IsSetCard(0x510) and c:IsType(TYPE_MONSTER))
end