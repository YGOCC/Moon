--Subzero Crystal - Illusionary Crystal
function c88890019.initial_effect(c)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(88890019,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c88890019.sptg1)
  e1:SetOperation(c88890019.spop1)
  c:RegisterEffect(e1)
  --(2) Place S/T Zone
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(88890019,10))
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e2:SetRange(LOCATION_HAND)
  e2:SetCost(c88890019.stzcost)
  e2:SetTarget(c88890019.stztg)
  e2:SetOperation(c88890019.stzop)
  c:RegisterEffect(e2)
end
--(1) Special Summon
function c88890019.spfilter1(c,e,tp)
  return c:IsFaceup() and c:IsSetCard(0x902) and bit.band(c:GetOriginalType(),0x81)==0x81
  and c:IsCanBeSpecialSummoned(e,0,tp,true,true) 
end
function c88890019.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c88890019.spfilter1(chkc,e,tp) end
  if chk==0 then return Duel.IsExistingTarget(c88890019.spfilter1,tp,LOCATION_SZONE,0,1,nil,e,tp)
  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c88890019.spfilter1,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c88890019.spop1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)~=0 then
    c:CancelToGrave()
    local code=tc:GetOriginalCode()
    --(1.1) Guardian Ecentramite
    if code==88890002 then
    
    end
    --(1.2) Guardian Suplimanate
    if code==88890004 then
    
    end
    --(1.3) Guardian Nethaninail
    if code==88890006 then
    
    end
    --(1.4) Guardian Leviathena
    if code==88890007 then
    
    end
    --(1.5) Guardian Pheoneta
    if code==88890008 then
    
    end
    --(1.6) Guardian Sorteactra
    if code==88890009 then
    
    end
    --(1.6) Supreme Ecentramite Zecrulation
    if code==88890001 then
    
    end
    --(1.7) Supreme Suplimanate Zecrulation
    if code==88890005 then

    end
  end
end
--(2) Place in S/T Zone
function c88890019.stzcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsDiscardable() end
  Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c88890019.stzfilter(c)
  return c:IsSetCard(0x902) and bit.band(c:GetType(),0x81)==0x81 and not c:IsForbidden()
end
function c88890019.stztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(c88890019.stzfilter,tp,LOCATION_DECK,0,1,nil)
  and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c88890019.stzop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectMatchingCard(tp,c88890019.stzfilter,tp,LOCATION_DECK,0,1,1,nil)
  local tc=g:GetFirst()
  if tc then
    Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    --Continuous Spell
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fc0000)
    e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
    tc:RegisterEffect(e1)
    Duel.RaiseEvent(tc,EVENT_CUSTOM+99020150,e,0,tp,0,0)
  end
end