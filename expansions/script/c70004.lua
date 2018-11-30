--"Espadachim - Devastating Ninja"
local m=70004
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Xyz Summon"
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x509),4,2,nil,nil,5)
    c:EnableReviveLimit()
    --"Special Summon"
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetDescription(aux.Stringid(70004,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c70004.cost)
    e1:SetTarget(c70004.sptg)
    e1:SetOperation(c70004.spop)
    c:RegisterEffect(e1,false,1)
    --"Draw"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(70004,1))
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(c70004.con)
    e2:SetTarget(c70004.tg)
    e2:SetOperation(c70004.op)
    c:RegisterEffect(e2)
end
function c70004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c70004.spfilter(c,e,tp)
    return c:IsSetCard(0x509) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c70004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c70004.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c70004.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c70004.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c70004.gfilter(c,tp)
    return c:IsSetCard(0x509) and c:IsControler(tp)
end
function c70004.con(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c70004.gfilter,1,nil,tp)
end
function c70004.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c70004.op(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end