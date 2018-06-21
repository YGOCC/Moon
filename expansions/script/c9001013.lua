--Ritualial Mirage
local m=9001013
local cm=_G["c"..m]
function cm.initial_effect(c)
    --Link Summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_RITUAL+TYPE_MONSTER),2,2)
    c:EnableReviveLimit()
    --Special Summon from GY
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetCondition(cm.hspcon)
    e1:SetOperation(cm.hspop)
    c:RegisterEffect(e1)
    --Add from Deck to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCountLimit(1)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(cm.cond)
    e2:SetTarget(cm.tgtg)
    e2:SetOperation(cm.tgop)
    c:RegisterEffect(e2)
end
--Special Summon from GY
function cm.hspfilter(c,ft,tp)
    return c:IsType(TYPE_RITUAL)
        and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function cm.hspcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    return ft>-1 and Duel.CheckReleaseGroup(tp,cm.hspfilter,1,nil,ft,tp)
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=Duel.SelectReleaseGroup(tp,cm.hspfilter,1,1,nil,ft,tp)
    Duel.Release(g,REASON_COST)
    c:RegisterFlagEffect(0,RESET_EVENT+0x4fc0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
end
function cm.cond(e,tp,eg,ep,ev,re,r,rp)
    return eg and eg:IsExists(cm.checkfilter,1,nil,tp)
end
function cm.checkfilter(c,tp)
    return c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thfilter2(c)
    return c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
