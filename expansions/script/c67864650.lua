--Mekbuster Peacekeeper IL9-Y2
function c67864650.initial_effect(c)
    c:EnableReviveLimit()
    --link summon
    aux.AddLinkProcedure(c,c67864650.matfilter,2)    
    --To Grave + Special Summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(67864650,1))
    e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c67864650.tgcon)
    e2:SetTarget(c67864650.tgtg)
    e2:SetOperation(c67864650.tgop)
    c:RegisterEffect(e2)
    --Special Summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(67864650,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetRange(EVENT_TO_GRAVE)
    e3:SetCondition(c67864650.spcon)
    e3:SetTarget(c67864650.sptg)
    e3:SetOperation(c67864650.spop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetRange(EVENT_REMOVE)
    c:RegisterEffect(e4)
    local e5=e3:Clone()
    e5:SetRange(EVENT_TO_DECK)
    c:RegisterEffect(e5)
end
function c67864650.matfilter(c)
    return c:IsRace(RACE_MACHINE) or c:IsSetCard(0x2a6)
end

function c67864650.desfilter(c)
    return c:IsFaceup() and c:IsCode(67864641)
end
function c67864650.tgcon(e)
    return not Duel.IsExistingMatchingCard(c67864650.desfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function c67864650.spfilter(c,e,tp)
    return c:IsCode(67864641) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67864650.tgfilter(c,lg)
    return c:IsAbleToGrave() and lg:IsContains(c)
end
function c67864650.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local lg=c:GetLinkedGroup()
    if chk==0 then return Duel.IsExistingMatchingCard(c67864650.spfilter,tp,LOCATION_GRAVE,0,1,nil)
        and Duel.IsExistingMatchingCard(c67864650.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lg) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,lg,lg:GetCount(),0,0)
end
function c67864650.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local lg=c:GetLinkedGroup():Filter(Card.IsAbleToGrave,nil)
    if Duel.SendtoGrave(lg,nil,REASON_EFFECT)~=0 then
        local g1=Duel.SelectMatchingCard(tp,c67864650.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
        if g1:GetCount()>0 then
            Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
function c67864650.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c67864650.spfilter1(c,e,tp)
    return c:IsSetCard(0x2a6) or (c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK))
        and c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67864650.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c67864650.spfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c67864650.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c67864650.spfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
