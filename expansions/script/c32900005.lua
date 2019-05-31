--Champion of the Fae
function c32900005.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(32900005,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_REMOVE)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetCondition(c32900005.spcon)
    e1:SetTarget(c32900005.sptg)
    e1:SetOperation(c32900005.spop)
    c:RegisterEffect(e1)
    --to grave
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(32900005,1))
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c32900005.tgtg)
    e2:SetOperation(c32900005.tgop)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(32900005,3))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCondition(c32900005.spcon1)
    e3:SetCost(aux.bfgcost)
    e3:SetTarget(c32900005.sptg1)
    e3:SetOperation(c32900005.spop1)
    c:RegisterEffect(e3)
    c32900005.banish_effect=e3
end
function c32900005.cfilter(c,tp)
    return c:IsSetCard(0x13b) and c:IsType(TYPE_MONSTER) and c:GetPreviousControler()==tp
        and c:IsPreviousLocation(LOCATION_MZONE+LOCATION_GRAVE)
end
function c32900005.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c32900005.cfilter,1,nil,tp)
end
function c32900005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c32900005.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function c32900005.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>0
        and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,0,0)
    if Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,32900001)>=3 then
        e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
    end
end
function c32900005.tgop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0 or Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g2=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
    g1:Merge(g2)
    Duel.SendtoGrave(g1,REASON_EFFECT)
    if Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1)
            and Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,32900001)>=3
            and Duel.SelectYesNo(tp,aux.Stringid(32900005,1)) then
            Duel.BreakEffect()
            Duel.Draw(tp,1,REASON_EFFECT)
            Duel.Draw(1-tp,1,REASON_EFFECT)
    end
end
function c32900005.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()==e:GetHandler():GetTurnID()+1
end
function c32900005.spfilter(c,e,tp)
    return c:IsCode(32900001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32900005.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c32900005.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 then
        e:SetLabel(1)
    else
        e:SetLabel(0)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c32900005.spop1(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c32900005.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if not tc then return end
    Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
    ft=ft-1
    local i=0
    while tc and i<2 and e:GetLabel()==1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and ft>0
        and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c32900005.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
        and Duel.SelectYesNo(tp,aux.Stringid(32900005,2)) do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        g=Duel.SelectMatchingCard(tp,c32900005.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
        tc=g:GetFirst()
        Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
        ft=ft-1
    end
    Duel.SpecialSummonComplete()
end