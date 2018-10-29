--Grimheart Grimoire
--Design by Reverie
--Script by NightcoreJack
function c39224958.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,39224958+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c39224958.condition)
    e1:SetTarget(c39224958.target)
    e1:SetOperation(c39224958.activate)
    c:RegisterEffect(e1)
end
function c39224958.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x37f)
end
function c39224958.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c39224958.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c39224958.tgfilter(c)
    return c:IsSetCard(0x37f) and c:IsAbleToGrave()
end
function c39224958.thfilter(c)
    return c:IsSetCard(0x37f) and c:IsAbleToHand()
end
function c39224958.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c39224958.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
    if not c:IsStatus(STATUS_ACT_FROM_HAND) and c:IsLocation(LOCATION_SZONE) then
        e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
    end
end
function c39224958.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c39224958.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
        if not c:IsStatus(STATUS_ACT_FROM_HAND) and c:IsLocation(LOCATION_SZONE) and Duel.SelectYesNo(tp,aux.Stringid(39224958,0)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local g2=Duel.SelectMatchingCard(tp,c39224958.thfilter,tp,LOCATION_DECK,0,1,1,nil)
            if g2:GetCount()>0 then
                Duel.SendtoHand(g2,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,g2)
            end
        end
    end
end