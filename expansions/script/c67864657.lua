--Mekbuster Engineer's Dream
function c67864657.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(c67864657.activate)
    c:RegisterEffect(e1)
    --atk&def
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE+RACE_WARRIOR))
    e2:SetValue(300)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(67864657,0))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetRange(LOCATION_FZONE)
    e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetCountLimit(1,67864657)
    e4:SetCondition(c67864657.spcon)
    e4:SetCost(c67864657.spcost)
    e4:SetTarget(c67864657.sptg)
    e4:SetOperation(c67864657.spop)
    c:RegisterEffect(e4)
end
function c67864657.filter(c)
    return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE) and c:IsLevelAbove(6) and c:IsType(TYPE_MONSTER)  and c:IsAbleToHand()
end
function c67864657.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c67864657.filter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(67864657,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function c67864657.cfilter(c,tp)
    return c:IsRace(RACE_WARRIOR) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
        and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c67864657.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c67864657.cfilter,1,nil,tp)
end
function c67864657.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(Card.IsAbleToRemove,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=eg:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c67864657.spfilter(c,e,tp)
    return c:IsSetCard(0x2a6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67864657.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c67864657.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c67864657.desfilter(c,atk)
    return c:IsDestructable() and c:GetAttack()<atk
end
function c67864657.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c67864657.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
    if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local dg=Duel.SelectMatchingCard(tp,c67864657.desfilter,tp,0,LOCATION_MZONE,1,1,nil,g:GetFirst():GetAttack())
        Duel.BreakEffect()
        Duel.Destroy(dg,REASON_EFFECT)
    end
end