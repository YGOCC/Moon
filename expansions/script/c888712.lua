--Kathline, Noon Star Bearer
local m=888712
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xff1),2,true)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(58811192,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetHintTiming(0,TIMING_END_PHASE)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCost(cm.spcost)
    e4:SetTarget(cm.sptg)
    e4:SetOperation(cm.spop)
    c:RegisterEffect(e4)    
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(22499034,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(cm.thcon)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToExtraAsCost() end
    Duel.SendtoDeck(c,nil,0,REASON_COST)
end
function cm.spfilter1(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xff1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.afilter(c,e,tp)
    return c:IsSetCard(0xff1)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return false end
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.GetMZoneCount(tp,e:GetHandler())>0
        and Duel.IsExistingTarget(cm.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectTarget(tp,cm.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    if g:GetCount()==0 then return end
    if g:GetCount()<=ft then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        local g2=Duel.SelectMatchingCard(tp,cm.afilter,tp,LOCATION_GRAVE,0,1,1,g)
        Duel.SendtoHand(g2,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g2)        
    end
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp
end
function cm.thfilter(c,tp)
    return c:IsSetCard(0xff1) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
