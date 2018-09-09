--Subzero Crystal - Galactis Fairy Reality Supleminack
function c88890021.initial_effect(c)
    c:EnableReviveLimit()
    c:EnableCounterPermit(0x77)
    c:SetUniqueOnField(1,1,aux.FilterBoolFunction(Card.IsSetCard,0x903),LOCATION_MZONE)
    --(1)cannot special summon
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_NEGATE)
    e0:SetRange(LOCATION_GRAVE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e0)
    local e1=e0:Clone()
    e1:SetRange(LOCATION_REMOVED)
    c:RegisterEffect(e1)
    --(2)Reality Summon
    aux.AddXyzProcedureLevelFree(c,c88890021.ovfilter,c88890021.xyzcheck,1,99)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(88890021,0))
    e2:SetCategory(CATEGORY_COUNTER)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_NEGATE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetTarget(c88890021.addtg)
    e2:SetOperation(c88890021.addop)
    e2:SetLabel(1)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --(3)Reality Time Limit
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(88890004,1))
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c88890021.rccon)
    e4:SetOperation(c88890021.rcop)
    c:RegisterEffect(e4)
    --(4)Time Limit Increase
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(88890021,5))
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetCondition(c88890021.addcon)
    e5:SetTarget(c88890021.addtg)
    e5:SetOperation(c88890021.addop)
    e5:SetLabel(6)
    c:RegisterEffect(e5)
    --(5)Place in spell/trap zone
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
    e7:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e7:SetCondition(c888900021.stzcon)
    e7:SetOperation(c888900021.stzop)
    c:RegisterEffect(e7)
    --(6) Not Xyz Monster
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_CONTINUOUS)
    e8:SetCode(EFFECT_REMOVE_TYPE)
    e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e8:SetRange(LOCATION_MZONE)
    e8:SetValue(TYPE_XYZ)
    c:RegisterEffect(e8)
    --(7) Ritual Summon
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(88890021,4))
    e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e9:SetType(EFFECT_TYPE_IGNITION)
    e9:SetRange(LOCATION_MZONE)
    e9:SetTarget(c88890021.sptg1)
    e9:SetOperation(c88890021.spop1)
    e9:SetCountLimit(1)
    c:RegisterEffect(e9)
    local e10=e9:Clone()
    e10:SetRange(LOCATION_SZONE)
    e10:SetCondition(c88890021.spcon1)
    c:RegisterEffect(e10)
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetCode(EFFECT_IMMUNE_EFFECT)
    e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetValue(c88890021.unfilter)
    e11:SetCondition(c88890021.uncon)
    c:RegisterEffect(e11)
    local e12=e11:Clone()
    e12:SetRange(LOCATION_SZONE)
    c:RegisterEffect(e12)
end
--(2)Reality Summon
function c88890021.ovfilter(c,xyzc)
    return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x902)
end
function c88890021.xyzcheck(g)
    return g:GetClassCount(Card.GetLevel)
end
function c88890021.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetLabel(),0,0x77)
end
function c88890021.addop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x77,e:GetLabel())
    end
end
--(3)Reality Time Limit
function c88890021.rccon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c88890021.rcop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local mon=e:GetHandler():GetOverlayGroup()
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x77,1,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x77,1,REASON_COST)
    if e:GetHandler():GetCounter(0x77)==0 then
        Duel.BreakEffect()
        Duel.Destroy(e:GetHandler(),REASON_EFFECT)
        Duel.SpecialSummon(mon,CATEGORY_SPECIAL_SUMMON,tp,tp,true,false,POS_FACEUP)
    end
end
function c88890021.descon(e)
    return e:GetHandler():GetCounter(0x77)==0
end
--(5) Time Limit Increase
function c88890021.addcon(e)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,88890001) or e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,88890005)
end
--(4) Place in S/T Zone
function c88890021.stzcon(e)
    local c=e:GetHandler()
    return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c88890021.stzop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    --Continuous Spell
    local e1=Effect.CreateEffect(c)
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fc0000)
    e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
    c:RegisterEffect(e1)
    Duel.RaiseEvent(c,EVENT_CUSTOM+88890010,e,0,tp,0,0)
    Duel.BreakEffect()
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(13474291,2))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c88890021.addcon)
    e2:SetTarget(c88890021.addtg)
    e2:SetOperation(c88890021.addop)
    e2:SetLabel(2)
    c:RegisterEffect(e2)
end
--(6) Ritual Summon
function c88890021.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsType(TYPE_SPELL+TYPE_CONTINUOUS) and not e:GetHandler():IsType(TYPE_EQUIP)
end
function c88890021.spfilter(c,e,tp)
  return c:IsSetCard(0x902) and c:GetLevel()==6 and c:IsType(TYPE_MONSTER+TYPE_RITUAL)
end
function c88890021.cfilter(c)
    return c:GetLevel()>0 and c:IsAbleToGrave()
end
function c88890021.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c88890021.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,g) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c88890021.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,g)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c88890021.spop1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    local mg=Duel.GetMatchingGroup(c88890021.cfilter,tp,LOCATION_MZONE+LOCATION_DECK,0,nil)
    if mg:GetCount()>0 then
        local rg=mg:SelectWithSumEqual(tp,Card.GetLevel,tc:GetLevel(),1,mg:GetCount(),tc)
        if Duel.SendtoGrave(rg,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL) then
            Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        end
    end
end
--(7) Unaffected
function c88890021.unfilter1(c)
    return c:IsFaceup() and c:IsSetCard(0x902) and c:IsType(TYPE_MONSTER+TYPE_RITUAL)
end
function c88890021.uncon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE+LOCATION_SZONE)>0 and
        Duel.IsExistingMatchingCard(c88890021.unfilter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
    and  c:IsType(TYPE_MONSTER) or c:IsType(TYPE_SPELL+TYPE_CONTINUOUS) and not c:IsType(TYPE_EQUIP)
end
function c88890021.unfilter(e,re)
    return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end