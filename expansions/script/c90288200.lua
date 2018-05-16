--Pandemoniumgraph Berserker 
local card = c90288200
function card.initial_effect(c)
    aux.AddOrigPandemoniumType(c)
    --Negate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90288200,1))
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_SZONE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetCondition(card.condition)
    e1:SetTarget(card.target)
    e1:SetOperation(card.operation)
    aux.EnablePandemoniumAttribute(c,e1)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90288200,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetTarget(card.settg)
    e2:SetOperation(card.setop)
    c:RegisterEffect(e2)
    end
function card.setfilter(c)
    return c:IsSetCard(0xcf80) and c:IsSSetable() and not c:IsCode(90288200)
end
function card.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(card.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function card.setop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,card.setfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SSet(tp,g:GetFirst())
        Duel.ConfirmCards(1-tp,g)
    end
end
function card.filter(c,tp)
    return c:IsControler(tp) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsSetCard(0xcf80)
end
function card.condition(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(card.filter,1,nil,tp)
        and Duel.IsChainNegatable(ev)
end
function card.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function card.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) then
        if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
            Duel.SendtoGrave(eg,REASON_EFFECT)
        end
        Duel.BreakEffect()
        Duel.Destroy(e:GetHandler(),REASON_EFFECT)
    end
end
