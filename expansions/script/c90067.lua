--"Script Kiddie"
local m=90067
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Link Material"
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c90067.matfilter,1,1)
    --"Search"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90067,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetTarget(c90067.thtg)
    e1:SetOperation(c90067.thop)
    c:RegisterEffect(e1)
    --"Handes"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90067,1))
    e2:SetCategory(CATEGORY_HANDES+CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_QUICK_F)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c90067.discon)
    e2:SetTarget(c90067.distarget)
    e2:SetOperation(c90067.disoperation)
    c:RegisterEffect(e2)
end
function c90067.matfilter(c,lc,sumtype,tp)
    return c:IsSetCard(0x1aa) and c:IsType(TYPE_NORMAL)
end
function c90067.thfilter(c)
    return c:IsCode(90069) and c:IsAbleToHand()
end
function c90067.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c90067.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c90067.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c90067.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c90067.discon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c90067.distarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c90067.disoperation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    if g:GetCount()>0 then
        local sg=g:RandomSelect(1-tp,1)
        Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
        local tc=sg:GetFirst()
        if tc:IsType(TYPE_MONSTER) then
            Duel.Damage(1-tp,tc:GetLevel()*200,REASON_EFFECT)
        end
    end
end