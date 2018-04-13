--Papirofly Call
function c89739473.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c89739473.target)
    e1:SetOperation(c89739473.activate)
    c:RegisterEffect(e1)
    --to grave
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetOperation(c89739473.regop)
    c:RegisterEffect(e2)
end
c89739473.fit_monster={89739467}
function c89739473.filter(c,e,tp,m,ft)
    if not c:IsCode(89739467) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
    if ft>0 then
        return mg:CheckWithSumEqual(Card.GetRitualLevel,7,1,99,c)
    else
        return mg:IsExists(c89739473.mfilterf,1,nil,tp,mg,c)
    end
end
function c89739473.mfilterf(c,tp,mg,rc)
    if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
        Duel.SetSelectedCard(c)
        return mg:CheckWithSumEqual(Card.GetRitualLevel,7,0,99,rc)
    else return false end
end
function c89739473.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg=Duel.GetRitualMaterial(tp)
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        return ft>-1 and Duel.IsExistingMatchingCard(c89739473.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg,ft)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c89739473.activate(e,tp,eg,ep,ev,re,r,rp)
    local mg=Duel.GetRitualMaterial(tp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,c89739473.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg,ft)
    local tc=tg:GetFirst()
    if tc then
        mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
        local mat=nil
        if ft>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,7,1,99,tc)
        else
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            mat=mg:FilterSelect(tp,c89739473.mfilterf,1,1,nil,tp,mg,tc)
            Duel.SetSelectedCard(mat)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,7,0,99,tc)
            mat:Merge(mat2)
        end
        tc:SetMaterial(mat)
        Duel.ReleaseRitualMaterial(mat)
        Duel.BreakEffect()
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
function c89739473.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) then
        local e3=Effect.CreateEffect(c)
        e3:SetDescription(aux.Stringid(89739473,1))
        e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
        e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
        e3:SetCode(EVENT_PHASE+PHASE_END)
        e3:SetCountLimit(1,89739473)
        e3:SetRange(LOCATION_GRAVE)
        e3:SetTarget(c89739473.thtg)
        e3:SetOperation(c89739473.thop)
        e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e3)
    end
end
function c89739473.thfilter(c)
    return c:IsSetCard(0x2bc) and c:IsAbleToHand()
end
function c89739473.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c89739473.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c89739473.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c89739473.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
