--Mechia Core
local m=8880807
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e2:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE)
    e2:SetCountLimit(1,8882807)
    e2:SetCost(cm.discost)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
    local e3=aux.AddRitualProcEqual2(c,cm.Ritfilter,nil,nil,cm.mfilter)
    e3:SetDescription(aux.Stringid(m,1))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_ONFIELD)
    e3:SetCountLimit(1,8883807)
    e3:SetRange(LOCATION_MZONE)
    c:RegisterEffect(e3)
end
function cm.Ritfilter(c)
    return c:IsSetCard(0xff8)
end
function cm.mfilter(c,e,tp)
    return c:IsType(TYPE_MONSTER)
end
function cm.spfilter(c)
    return c:IsFaceup() and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsAbleToGraveAsCost() and c:IsSetCard(0xff8)
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_ONFIELD,0,1,c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_ONFIELD,0,1,1,c)
    Duel.SendtoGrave(g,REASON_COST)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
    end
end