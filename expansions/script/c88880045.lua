--Rank-Up-Magic Ultra Neon Advancment
--Scripted by Raivost
function c88880045.initial_effect(c)
    --(1) Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(88880045,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c88880045.sptg)
    e1:SetOperation(c88880045.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetValue(c88880045.atkval)
    e2:SetTarget(c88880045.atktg)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)
  end
function c88880045.spfilter1(c,e,tp)
  return c:IsFaceup() and c:IsSetCard(0x895) and c:IsType(TYPE_XYZ) and Duel.GetLocationCountFromEx(tp,tp,c)>0
  and Duel.IsExistingMatchingCard(c88880045.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,13)
end
function c88880045.spfilter2(c,e,tp,mc,rk)
  if c.rum_limit and not c.rum_limit(mc,e) then return false end
  return c:GetRank()==rk and c:IsSetCard(0x896) and mc:IsCanBeXyzMaterial(c)
  and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c88880045.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c88880045.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,c88880045.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
  if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
    Duel.SetChainLimit(aux.FALSE)
  end
end
function c88880045.spop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
  if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c88880045.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,13)
  local sc=g:GetFirst()
  if sc then
    local mg=tc:GetOverlayGroup()
    if mg:GetCount()~=0 then
      Duel.Overlay(sc,mg)
    end
    sc:SetMaterial(Group.FromCards(tc))
    Duel.Overlay(sc,Group.FromCards(tc))
    if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
        local c=e:GetHandler()
        Duel.Equip(tp,c,sc)
        c:CancelToGrave()
        --Add Equip limit
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetValue(c88880045.eqlimit)
        e1:SetLabelObject(sc)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        c:RegisterEffect(e1)
        sc:CompleteProcedure()
        end
    end
end
function c88880045.atktg(e,c)
    return c==e:GetHandler():GetEquipTarget()
end
function c88880045.eqlimit(e,c)
  return c==e:GetLabelObject()
end
function c88880045.atkval(e,c)
  local g=Duel.GetMatchingGroup(Card.IsFaceup,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)
  return g:GetSum(Card.GetLevel)*300 + g:GetSum(Card.GetRank)*300
end