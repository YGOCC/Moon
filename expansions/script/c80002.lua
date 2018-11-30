--"Espada Demoníaca - Inseparable Soul"
local m=80002
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Activate"
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(80002,0))
    e0:SetCategory(CATEGORY_EQUIP)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e0:SetTarget(c80002.eqtg)
    e0:SetOperation(c80002.eqop)
    c:RegisterEffect(e0)
    --"Atk UP"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_EQUIP)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(500)
    c:RegisterEffect(e1)
    --"Equip Limit"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EQUIP_LIMIT)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetValue(c80002.eqlimit)
    c:RegisterEffect(e2)
    --"Search"
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(80002,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,80002)
    e3:SetCost(c80002.scost)
    e3:SetTarget(c80002.starget)
    e3:SetOperation(c80002.soperation)
    c:RegisterEffect(e3)
    --"Special Summon"
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(80002,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_CHAINING)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCountLimit(1,80002)
    e4:SetCondition(c80002.spcon)
    e4:SetTarget(c80002.sptg)
    e4:SetOperation(c80002.spop)
    c:RegisterEffect(e4)
end
function c80002.eqfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x509)
end
function c80002.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c80002.eqfilter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c80002.eqfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c80002.eqfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c80002.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    Duel.Equip(tp,c,tc,true)
    --"ATK UP #1"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_EQUIP)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(500)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EQUIP_LIMIT)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
    e2:SetValue(c80002.eqlimit)
    e2:SetLabelObject(tc)
    c:RegisterEffect(e2)
    --"ATK UP #2"
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetCondition(c80002.atkcon)
    e3:SetValue(c80002.atkval)
    e3:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e3)
end
function c80002.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function c80002.atkcon(e)
    return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
        and Duel.GetAttacker()==e:GetHandler():GetEquipTarget() and Duel.GetAttackTarget()
end
function c80002.atkval(e,c)
    return Duel.GetAttackTarget():GetAttack()/2
end
function c80002.scost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c80002.sfilter(c)
    return c:IsSetCard(0x509) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c80002.starget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
     if chk==0 then return Duel.IsExistingMatchingCard(c80002.sfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
        e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
end
function c80002.soperation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c80002.sfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c80002.spcon(e,tp,eg,ep,ev,re,r,rp)
     return re:IsActiveType(TYPE_MONSTER)
end
function c80002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(80002)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,80002,0x510,0x11,500,0,1,RACE_FIEND,ATTRIBUTE_DARK) end
    c:RegisterFlagEffect(80002,RESET_CHAIN,0,1)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c80002.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,80002,0x510,0x11,500,0,1,RACE_FIEND,ATTRIBUTE_DARK) then
        c:AddMonsterAttribute(TYPE_EFFECT)
        Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
        c:AddMonsterAttributeComplete()
        --"Cannot Attack"
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_ATTACK)
        c:RegisterEffect(e1,true)
        Duel.SpecialSummonComplete()
    end
end