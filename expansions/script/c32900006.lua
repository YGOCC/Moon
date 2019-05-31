--Princess of the Fae
function c32900006.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(32900006,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c32900006.spcon)
    e1:SetTarget(c32900006.sptg)
    e1:SetOperation(c32900006.spop)
    c:RegisterEffect(e1)
    --summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(32900006,2))
    e2:SetCategory(CATEGORY_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c32900006.sumtg)
    e2:SetOperation(c32900006.sumop)
    c:RegisterEffect(e2)
    --add/special
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetDescription(aux.Stringid(32900006,2))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCondition(c32900006.condition)
    e3:SetCost(aux.bfgcost)
    e3:SetTarget(c32900006.target)
    e3:SetOperation(c32900006.operation)
    c:RegisterEffect(e3)
    c32900006.banish_effect=e3
end
function c32900006.cfilter(c,tp)
    return c:IsSetCard(0x13b) and c:IsType(TYPE_MONSTER) and not c:IsCode(32900006) and c:IsControler(tp)
end
function c32900006.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c32900006.cfilter,1,nil,tp)
end
function c32900006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c32900006.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c32900006.sumfilter(c)
    return c:IsSetCard(0x13b) and not c:IsCode(32900006) and c:IsSummonable(true,nil)
end
function c32900006.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c32900006.sumfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c32900006.sumop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c32900006.sumfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if c:IsRelateToEffect(e) and g:GetCount()>0 then
        Duel.Summon(tp,g:GetFirst(),true,nil)
    end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c32900006.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()==e:GetHandler():GetTurnID()+1
end
function c32900006.filter(c,e,tp,chk)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_FAIRY)
        and (c:IsAbleToHand() or chk and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c32900006.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local res=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,32900001)>=3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        return Duel.IsExistingMatchingCard(c32900006.filter,tp,LOCATION_DECK,0,1,nil,e,tp,res)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c32900006.operation(e,tp,eg,ep,ev,re,r,rp)
    local res=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,32900001)>=3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local tc=Duel.SelectMatchingCard(tp,c32900006.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,res):GetFirst()
    if tc then
        if res and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
            and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
            Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        else
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc)
        end
    end
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c32900006.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c32900006.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsAttribute(ATTRIBUTE_WIND)
end