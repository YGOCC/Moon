--32083001
function c32083001.initial_effect(c)
--Special Summon from deck
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(32083001,1))
e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
e1:SetCategory(CATEGORY_REMOVE)
e1:SetType(EFFECT_TYPE_QUICK_O)
e1:SetRange(LOCATION_HAND)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetCountLimit(1,32083001+EFFECT_COUNT_CODE_OATH)
e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
e1:SetCost(c32083001.cost)
e1:SetTarget(c32083001.target)
e1:SetOperation(c32083001.operation)
c:RegisterEffect(e1)
--Special Summon banished 
local e2=Effect.CreateEffect(c)
e2:SetDescription(aux.Stringid(32083001,0))
e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
e2:SetCategory(CATEGORY_REMOVE)
e2:SetType(EFFECT_TYPE_QUICK_O)
e2:SetRange(LOCATION_MZONE)
e2:SetCode(EVENT_FREE_CHAIN)
e2:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
e2:SetCost(c32083001.rmcost)
e2:SetTarget(c32083001.rmtg)
e2:SetOperation(c32083001.rmop)
c:RegisterEffect(e2)
end
function c32083001.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return e:GetHandler():IsAbleToRemove() end
Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c32083001.filter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)and c:IsSetCard(0x7D53)and c:GetCode()~=32083001
end
function c32083001.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c32083001.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingTarget(c32083001.filter,tp,LOCATION_REMOVED,LOCATION_REMOVE,1,nil,e,tp,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
   local g=Duel.SelectTarget(tp,c32083001.filter,tp,LOCATION_REMOVED,LOCATION_REMOVE,1,1,nil,e,tp,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c32083001.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c32083001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c32083001.xfilter(c,e,tp)
return c:IsSetCard(0x7D53)and c:IsLevelBelow(4)
and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32083001.target(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
and Duel.IsExistingMatchingCard(c32083001.xfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c32083001.operation(e,tp,eg,ep,ev,re,r,rp)
if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
local g=Duel.SelectMatchingCard(tp,c32083001.xfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
if g:GetCount()>0 then
Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
end