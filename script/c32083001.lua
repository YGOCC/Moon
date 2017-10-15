--32083001
function c32083001.initial_effect(c)
--remove
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(32083001,0))
e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
e1:SetCategory(CATEGORY_REMOVE)
e1:SetType(EFFECT_TYPE_QUICK_O)
e1:SetRange(LOCATION_MZONE)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
e1:SetCost(c32083001.rmcost)
e1:SetTarget(c32083001.rmtg)
e1:SetOperation(c32083001.rmop)
c:RegisterEffect(e1)
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