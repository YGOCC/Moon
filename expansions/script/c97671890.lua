--Wyndbreaker Victorie
function c97671890.initial_effect(c)
    --tograve
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(97671890,0))
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,97671890)
    e1:SetTarget(c97671890.target)
    e1:SetOperation(c97671890.operation)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_RELEASE)
    e3:SetCountLimit(1,97672890)
    e3:SetTarget(c97671890.target1)
    e3:SetOperation(c97671890.operation1)
    c:RegisterEffect(e3)
end
function c97671890.filter(c)
    return c:IsSetCard(0xd70) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c97671890.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c97671890.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c97671890.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c97671890.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
function c97671890.filter1(c)
    return c:IsSetCard(0xd70) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c97671890.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c97671890.filter1,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c97671890.operation1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c97671890.filter1,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end