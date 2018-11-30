--"Espada Demoníaca - Demon Emperor's Blade"
local m=80009
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Activate"
    local e0=Effect.CreateEffect(c)
    e0:SetCategory(CATEGORY_EQUIP)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e0:SetTarget(c80009.target)
    e0:SetOperation(c80009.operation)
    c:RegisterEffect(e0)
    --"ATK Change"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_EQUIP)
    e1:SetCode(EFFECT_SET_ATTACK)
    e1:SetCondition(c80009.ATKCcondition)
    e1:SetValue(c80009.ATKCvalue)
    c:RegisterEffect(e1)
    --"Shuffle and Draw"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(80009,0))
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,80009)
    e2:SetTarget(c80009.SStarget)
    e2:SetOperation(c80009.SSoperation)
    c:RegisterEffect(e2)
    --"Change Position"
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(80009,1))
    e3:SetCategory(CATEGORY_POSITION)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetHintTiming(TIMING_BATTLE_PHASE)
    e3:SetCountLimit(1)
    e3:SetCost(c80009.CPoscost)
    e3:SetTarget(c80009.CPostg)
    e3:SetOperation(c80009.CPosop)
    c:RegisterEffect(e3)
    --"Pierce"
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_EQUIP)
    e4:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e4)
    --"Special Summon"
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(80009,2))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_CHAINING)
    e5:SetRange(LOCATION_GRAVE)
    e5:SetCondition(c80009.spcon)
    e5:SetTarget(c80009.sptg)
    e5:SetOperation(c80009.spop)
    c:RegisterEffect(e5)
    --"Equip Limit"
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_EQUIP_LIMIT)
    e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e6:SetValue(c80009.eqlimit)
    c:RegisterEffect(e6)
end
function c80009.eqlimit(e,c)
    return c:IsSetCard(0x509) and c:IsType(TYPE_LINK)
end
function c80009.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x509) and c:IsType(TYPE_LINK)
end
function c80009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c80009.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c80009.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c80009.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
end
function c80009.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,c,tc)
    end
end
function c80009.ATKCcondition(e)
    return Duel.GetLP(0)~=Duel.GetLP(1)
end
function c80009.ATKCvalue(e,c)
    local p=e:GetHandler():GetControler()
    if Duel.GetLP(p)<Duel.GetLP(1-p) then
        return c:GetBaseAttack()*2
    elseif Duel.GetLP(p)>Duel.GetLP(1-p) then
        return c:GetBaseAttack()/2
    end
end
function c80009.SSfilter(c)
    return c:IsSetCard(0x510)
end
function c80009.SStarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp)
        and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c80009.SSoperation(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(g,c80009.SSfilter,p,LOCATION_GRAVE,0,1,63,nil)
    if g:GetCount()==0 then return end
    Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    Duel.ShuffleDeck(p)
    Duel.BreakEffect()
    Duel.Draw(p,g:GetCount(),REASON_EFFECT)
end
function c80009.CPoscost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0x509) end
    local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0x509)
    Duel.Release(g,REASON_COST)
end
function c80009.CPosfilter(c)
    return not c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanChangePosition()
end
function c80009.CPostg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c80009.CPosfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c80009.CPosfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    Duel.SelectTarget(tp,c80009.CPosfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c80009.CPosop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and not tc:IsPosition(POS_FACEUP_DEFENSE) then
        Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
    end
end
function c80009.spcon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c80009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(80009)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,80009,0x510,0x11,0,1000,8,RACE_FAIRY,ATTRIBUTE_DARK) end
    c:RegisterFlagEffect(80009,RESET_CHAIN,0,1)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c80009.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,80009,0x510,0x11,0,1000,8,RACE_FAIRY,ATTRIBUTE_DARK) then
        c:AddMonsterAttribute(TYPE_EFFECT)
        Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
        c:AddMonsterAttributeComplete()
        local e1=Effect.CreateEffect(c)
        e1:SetDescription(aux.Stringid(80009,3))
        e1:SetCategory(CATEGORY_ATKCHANGE)
        e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
        e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
        e1:SetCode(EVENT_SPSUMMON_SUCCESS)
        e1:SetTarget(c80009.Ctarget)
        e1:SetOperation(c80009.Coperation)
        c:RegisterEffect(e1,true)
        Duel.SpecialSummonComplete()
    end
end
function c80009.Ctarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c80009.Coperation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) and tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_ATTACK_FINAL)
        e2:SetValue(tc:GetBaseAttack())
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
        c:RegisterEffect(e2)
    end
end