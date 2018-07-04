--Subzero Crystal - Unlimited Crystalized Potential
function c88890018.initial_effect(c)
  --(1) Activate
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(88890018,0))
  e1:SetCategory(CATEGORY_TODECK)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetTarget(c88890018.actg)
  e1:SetOperation(c88890018.acop)
  c:RegisterEffect(e1)
end
--(1) Activate
function c88890018.acfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x902) and bit.band(c:GetOriginalType(),0x81)==0x81 and c:IsAbleToDeck()
end
function c88890018.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingTarget(c88890018.acfilter,tp,LOCATION_SZONE,0,1,nil) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g=Duel.SelectTarget(tp,c88890018.acfilter,tp,LOCATION_SZONE,0,1,1,nil)
  Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c88890018.acop(e,tp,eg,ep,ev,re,r,rp)
  if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
  local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
    c:CancelToGrave()
    local code=tc:GetOriginalCode()
    --(1.1) Guardian Ecentramite
    if code==88890002 then
      --Gain LP 1
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(aux.Stringid(88890018,1))
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT)
      e1:SetRange(LOCATION_SZONE)
      e1:SetCode(EFFECT_CANNOT_SUMMON)
      e1:SetValue(c88890018.recop1)
      c:RegisterEffect(e1)
    end
    --(1.2) Guardian Suplimanate
    if code==88890004 then
      --Unaffected
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(aux.Stringid(88890018,2))
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT)
      e1:SetRange(LOCATION_SZONE)
      e1:SetCode(EFFECT_CANNOT_SUMMON)
      e1:SetValue(c88890018.unfop)
      c:RegisterEffect(e1)
    end
    --(1.3) Guardian Nethaninail
    if code==88890006 then
      --Gain ATK
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(aux.Stringid(88890018,3))
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT)
      e1:SetRange(LOCATION_SZONE)
      e1:SetCode(EFFECT_CANNOT_SUMMON)
      e1:SetValue(c88890018.banop1)
      c:RegisterEffect(e1)
    end
    --(1.4) Guardian Leviathena
    if code==88890007 then
      --Banish 1
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(aux.Stringid(88890018,4))
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT)
      e1:SetRange(LOCATION_SZONE)
      e1:SetCode(EFFECT_CANNOT_SUMMON)
      e1:SetValue(c88890018.damop)
      c:RegisterEffect(e1)
    end
    --(1.5) Guardian Pheoneta
    if code==88890008 then
      --Inflict Damage
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(aux.Stringid(88890018,5))
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT)
      e1:SetRange(LOCATION_SZONE)
      e1:SetCode(EFFECT_CANNOT_SUMMON)
      e1:SetValue(c88890018.damop1)
      c:RegisterEffect(e1)
    end
    --(1.6) Guardian Sorteactra
    if code==88890009 then
      --Inflict Damage
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(aux.Stringid(88890018,6))
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT)
      e1:SetRange(LOCATION_SZONE)
      e1:SetCode(EFFECT_CANNOT_SUMMON)
      e1:SetValue(c88890018.damop2)
      c:RegisterEffect(e1)
    end
    --(1.6) Supreme Ecentramite Zecrulation
    if code==88890001 then
      --Special Summon
      local e1=Effect.CreateEffect(c)
      e1:SetDescription(aux.Stringid(88890018,7))
      e1:SetType(EFFECT_TYPE_QUICK_O)
      e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
      e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CLIENT_HINT)
      e1:SetRange(LOCATION_SZONE)
      e1:SetCode(EVENT_FREE_CHAIN)
      e1:SetCountLimit(1)
      e1:SetOperation(c88890018.spop)
      e1:SetReset(RESET_EVENT+0x1fe0000)
      c:RegisterEffect(e1)
    end
    --(1.7) Supreme Suplimanate Zecrulation
    if code==88890005 then
      --Normal Summon Restrict

    end
    --(1.8) Draw
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(88890018,8))
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1,88890018)
    e2:SetCondition(c88890018.drcon)
    e2:SetTarget(c88890018.drtg)
    e2:SetOperation(c88890018.drop)
    e2:SetReset(RESET_EVENT+0x1fe0000)
    c:RegisterEffect(e2)
    --(1.9) Gain LP
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(88890018,9))
    e3:SetCategory(CATEGORY_RECOVER)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(c88890018.reccon2)
    e3:SetTarget(c88890018.rectg2)
    e3:SetOperation(c88890018.recop2)
    e3:SetReset(RESET_EVENT+0x1fe0000)
    c:RegisterEffect(e3)
  end
end
--(1.1) Guardian Ecentramite
function c88890018.recop1(e,tp,eg,ep,ev,re,r,rp)
  return c:IsAttribute(ATTRIBUTE_LIGHT)
end
--(1.2) Guardian Suplimanate
function c88890018.unfop(e,tp,eg,ep,ev,re,r,rp)
  return c:IsAttribute(ATTRIBUTE_DARK)
end
--(1.3) Guardian Nethaninail
function c88890018.banop1(e,tp,eg,ep,ev,re,r,rp)
  return c:IsAttribute(ATTRIBUTE_WIND)
end
--(1.4) Guardian Leviathena
function c88890018.damop(e,tp,eg,ep,ev,re,r,rp)
  return c:IsAttribute(ATTRIBUTE_WATER)
end
--(1.5) Guardian Pheoneta
function c88890018.damop1(e,tp,eg,ep,ev,re,r,rp)
  return c:IsAttribute(ATTRIBUTE_FIRE)
end
--(1.6) Guardian Sorteactra
function c88890018.damop2(e,tp,eg,ep,ev,re,r,rp)
  return c:IsAttribute(ATTRIBUTE_EARTH)
end
--(1.7) Supreme Ecentramite Zecrulation
function c88890018.spfilter(c,e,tp)
    return c:IsSetCard(0x902) and c:GetType()==TYPE_MONSTER+TYPE_RITUAL and c:IsAbleToHand()
end
function c88890018.spop(e,tp,eg,ep,ev,re,r,rp)
    if chk==0 then return Duel.IsExistingMatchingCard(c88890001.spfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--(1.8) Supreme Suplimanate Zecrulation

--Place S/T Zone | Send to Grave
function c88890018.pgop(e,tp,eg,ep,ev,re,r,rp)
  local tc=e:GetLabelObject()
  Duel.HintSelection(Group.FromCards(tc))
  local select=0
  Duel.Hint(HINT_SELECTMSG,tp,0)
  if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
    select=Duel.SelectOption(tp,aux.Stringid(88890018,12),aux.Stringid(88890018,13))
  else
    select=Duel.SelectOption(tp,aux.Stringid(88890018,13))
    select=1
  end
  if select==0 then
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
  else
    Duel.SendtoGrave(tc,REASON_EFFECT)
  end
end
--(1.8) Draw
function c88890018.drconfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x902) and bit.band(c:GetType(),0x81)==0x81 and c:GetSummonPlayer()==tp
end
function c88890018.drcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c88890018.drconfilter,1,nil,tp)
end
function c88890018.drfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x902) and bit.band(c:GetType(),0x81)==0x81
end
function c88890018.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  local ct=Duel.GetMatchingGroupCount(c88890018.drfilter,tp,LOCATION_MZONE,0,nil)
  if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
  Duel.SetTargetPlayer(tp)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c88890018.drop(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
  local ct=Duel.GetMatchingGroupCount(c88890018.drfilter,tp,LOCATION_MZONE,0,nil)
  if ct>0 then
    Duel.Draw(p,ct,REASON_EFFECT)
  end
end
--(1.9) Gain Lp 2
function c88890018.recfilter2(c,tp)
  local pl=c:GetPreviousLocation()
  return c:IsPreviousSetCard(0x902) and c:GetPreviousControler()==tp 
  and ((c:IsType(TYPE_MONSTER) and pl==LOCATION_MZONE) or (c:IsLevelAbove(1) and pl==LOCATION_SZONE))
end
function c88890018.reccon2(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c88890018.recfilter2,1,nil,tp)
end
function c88890018.rectg2(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(500)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c88890018.recop2(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  Duel.Recover(p,d,REASON_EFFECT)
end