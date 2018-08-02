--ASSASSIN - ARMORED MASTER
function c18691867.initial_effect(c)
    --cannot trigger
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_TRIGGER)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0xa,0xa)
    e1:SetTarget(c18691867.distg)
    c:RegisterEffect(e1)
    --disable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DISABLE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e2:SetTarget(c18691867.distg)
    c:RegisterEffect(e2)
    --disable effect
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_CHAIN_SOLVING)
    e3:SetRange(LOCATION_MZONE)
    e3:SetOperation(c18691867.disop)
    c:RegisterEffect(e3)
    --disable trap monster
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e4:SetTarget(c18691867.distg)
    c:RegisterEffect(e4)
    --search
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(18691867,0))
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_SUMMON_SUCCESS)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e5:SetTarget(c18691867.thtg)
    e5:SetOperation(c18691867.thop)
    c:RegisterEffect(e5)
end
function c18691867.filter(c)
    return c:IsCode(18691868) and c:IsAbleToHand()
end
function c18691867.distg(e,c)
    return c:IsType(TYPE_TRAP)
end
function c18691867.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c18691867.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c18691867.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c18691867.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c18691867.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:IsActiveType(TYPE_TRAP) then
        Duel.NegateEffect(ev)
    end
end

