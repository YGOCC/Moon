--"Espada Demoníaca - Hell Breeze"
local m=80010
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Link Materials"
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x510),3,3)
    --"Only One"
    c:SetUniqueOnField(1,0,80010)
    --"ATK Down"
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(80010,0))
    e0:SetCategory(CATEGORY_ATKCHANGE)
    e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e0:SetCode(EVENT_SPSUMMON_SUCCESS)
    e0:SetCondition(c80010.atkcon)
    e0:SetOperation(c80010.atkop)
    c:RegisterEffect(e0)
    --"Gains ATK"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(c80010.GATKvalue)
    c:RegisterEffect(e1)
    --"Set Card"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(80010,1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c80010.SETtarget)
    e2:SetOperation(c80010.SEToperation)
    c:RegisterEffect(e2)
    --"Return and Draw"
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(80010,2))
    e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,80010)
    e3:SetTarget(c80010.RDtarget)
    e3:SetOperation(c80010.RDactivate)
    c:RegisterEffect(e3)
    --"Recover LP"
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c80010.Reccon)
    e4:SetOperation(c80010.Recop)
    c:RegisterEffect(e4)
    --"Gain ATK and DEF"
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e5:SetTarget(c80010.GTDtg)
    e5:SetValue(200)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e6)
    --"Cannot Be Target"
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e7:SetCondition(c80010.CBTcon)
    e7:SetValue(1)
    c:RegisterEffect(e7)
    local e8=e7:Clone()
    e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    c:RegisterEffect(e8)
    --"Destroy"
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(80010,3))
    e9:SetCategory(CATEGORY_DESTROY)
    e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e9:SetCode(EVENT_BATTLE_DESTROYING)
    e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e9:SetRange(LOCATION_SZONE)
    e9:SetCondition(c80010.descon)
    e9:SetTarget(c80010.destg)
    e9:SetOperation(c80010.desop)
    c:RegisterEffect(e9)
end
function c80010.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c80010.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(0)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
end
function c80010.GATKfilter(c)
    return c:IsSetCard(0x510) and c:IsType(TYPE_EQUIP)
end
function c80010.GATKvalue(e,c)
    local g=Duel.GetMatchingGroup(c80010.GATKfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
    local ct=g:GetClassCount(Card.GetCode)
    return ct*300
end
function c80010.SETfilter(c)
    return c:IsCode(80009) and c:IsSSetable()
end
function c80010.SETtarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c80010.SETfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c80010.SEToperation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,c80010.SETfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SSet(tp,g:GetFirst())
        Duel.ConfirmCards(1-tp,g)
    end
end
function c80010.RDfilter(c)
    return c:IsSetCard(0x510) and c:IsAbleToDeck()
end
function c80010.RDtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()==tp and c80010.RDfilter(chkc) end
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) 
        and Duel.IsExistingTarget(c80010.RDfilter,tp,LOCATION_GRAVE,0,3,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c80010.RDfilter,tp,LOCATION_GRAVE,0,3,3,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c80010.RDactivate(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    if ct==3 then
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
function c80010.Recfilter(c,ec)
    if c:IsLocation(LOCATION_MZONE) then
        return c:IsSetCard(0x509) and c:IsFaceup() and ec:GetLinkedGroup():IsContains(c)
    else
        return c:IsPreviousSetCard(0x509) and c:IsPreviousPosition(POS_FACEUP)
            and bit.extract(ec:GetLinkedZone(c:GetPreviousControler()),c:GetPreviousSequence())~=0
    end
end
function c80010.Reccon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c80010.Recfilter,1,nil,e:GetHandler())
end
function c80010.Recop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,80010)
    Duel.Recover(tp,400,REASON_EFFECT)
end
function c80010.GTDtg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0x509)
end
function c80010.CBTfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x509)
end
function c80010.CBTcon(e)
    return Duel.IsExistingMatchingCard(c80010.CBTfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c80010.descon(e,tp,eg,ep,ev,re,r,rp)
    local ec=eg:GetFirst()
    local bc=ec:GetBattleTarget()
    return e:GetHandler():GetEquipTarget()==eg:GetFirst() and ec:IsControler(tp)
        and bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE)
end
function c80010.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c80010.desop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end