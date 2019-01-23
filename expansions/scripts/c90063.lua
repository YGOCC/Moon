--"FeedBack, The Amateur Hacker"
local m=90063
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Pendulum Attribute"
    aux.EnablePendulumAttribute(c)
    --"Search"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90063,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTarget(c90063.thtg)
    e1:SetOperation(c90063.thop)
    c:RegisterEffect(e1)
    --"Damage"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90063,1))
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(c90063.damcon)
    e2:SetTarget(c90063.damtg)
    e2:SetOperation(c90063.damop)
    c:RegisterEffect(e2)
end
function c90063.filter(c)
    return c:IsSetCard(0x1aa) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c90063.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c90063.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c90063.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c90063.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c90063.damfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c90063.damcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c90063.damfilter,1,nil)
end
function c90063.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(200)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
end
function c90063.damop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end