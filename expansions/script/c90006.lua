--"Cyberon Network"
--by "Márcio Eduine"
local m=90006
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Only One"
    c:SetUniqueOnField(1,0,90006)
    --"activate"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --"Summon"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90006,0))
    e2:SetCategory(CATEGORY_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,90006)
    e2:SetTarget(c90006.sumtg)
    e2:SetOperation(c90006.sumop)
    c:RegisterEffect(e2)
    --"Draw"
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(90006,1))
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(c90006.condition)
    e3:SetTarget(c90006.target)
    e3:SetOperation(c90006.operation)
    c:RegisterEffect(e3)
    --"Salvage"
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(90006,2))
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCost(c90006.cost2)
    e4:SetTarget(c90006.tg)
    e4:SetOperation(c90006.op)
    c:RegisterEffect(e4)
end
function c90006.sumfilter(c)
    return c:IsSetCard(0x20aa) and c:IsSummonable(true,nil)
end
function c90006.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c90006.sumfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c90006.sumop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,c90006.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.Summon(tp,tc,true,nil)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c90006.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c90006.splimit(e,c)
    return not c:IsSetCard(0x20aa) and c:IsLocation(LOCATION_EXTRA)
end
function c90006.filter(c,tp)
    return c:IsSetCard(0x20aa) and c:IsControler(tp) and (c:IsSummonType(SUMMON_TYPE_FUSION) or c:IsSummonType(SUMMON_TYPE_LINK))
end
function c90006.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c90006.filter,1,nil,tp)
end
function c90006.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c90006.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
function c90006.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
    Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c90006.thfilter(c)
    return c:IsSetCard(0x20aa) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c90006.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c90006.thfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c90006.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c90006.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c90006.op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end
end