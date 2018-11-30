--"Espada Demoníaca - Vision of Hell"
local m=80003
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Activate"
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(80003,0))
    e0:SetCategory(CATEGORY_EQUIP)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e0:SetTarget(c80003.eqtg)
    e0:SetOperation(c80003.eqop)
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
    e2:SetValue(c80003.eqlimit)
    c:RegisterEffect(e2)
    --"Search"
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(80003,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,80003)
    e3:SetCost(c80003.scost)
    e3:SetTarget(c80003.starget)
    e3:SetOperation(c80003.soperation)
    c:RegisterEffect(e3)
    --"Special Summon"
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(80003,4))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_CHAINING)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCountLimit(1,80003)
    e4:SetCondition(c80003.spcon)
    e4:SetTarget(c80003.sptg)
    e4:SetOperation(c80003.spop)
    c:RegisterEffect(e4)
    --"Confirm"
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(80003,2))
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCountLimit(1)
    e5:SetTarget(c80003.cftg)
    e5:SetOperation(c80003.cfop)
    c:RegisterEffect(e5)
    --"Damage"
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(80003,3))
    e6:SetCategory(CATEGORY_DAMAGE)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e6:SetCode(EVENT_BATTLE_DAMAGE)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetRange(LOCATION_SZONE)
    e6:SetCondition(c80003.damcon)
    e6:SetCost(c80003.damcost)
    e6:SetTarget(c80003.damtg)
    e6:SetOperation(c80003.damop)
    c:RegisterEffect(e6)
end
function c80003.eqfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x509)
end
function c80003.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c80003.eqfilter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c80003.eqfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c80003.eqfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c80003.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    Duel.Equip(tp,c,tc,true)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EQUIP_LIMIT)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
    e2:SetValue(c80003.eqlimit)
    e2:SetLabelObject(tc)
    c:RegisterEffect(e2)
end
function c80003.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function c80003.cftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function c80003.cfop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    if g:GetCount()==0 then return end
    local sg=g:RandomSelect(tp,1)
    Duel.ConfirmCards(tp,sg)
    Duel.ShuffleHand(1-tp)
end
function c80003.damcon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and eg:GetFirst()==e:GetHandler():GetEquipTarget()
end
function c80003.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c80003.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(800)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c80003.damop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
function c80003.scost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
    Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c80003.sfilter(c)
    return c:IsSetCard(0x509) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c80003.starget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
     if chk==0 then return Duel.IsExistingMatchingCard(c80003.sfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
        e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
end
function c80003.soperation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c80003.sfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c80003.spcon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c80003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(80003)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,80003,0x510,0x11,0,500,1,RACE_FIEND,ATTRIBUTE_DARK) end
    c:RegisterFlagEffect(80003,RESET_CHAIN,0,1)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c80003.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,80003,0x510,0x11,0,500,1,RACE_FIEND,ATTRIBUTE_DARK) then
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