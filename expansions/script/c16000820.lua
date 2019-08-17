--Medivatale Tortoise
local ref=_G['c'..16000820]
function c16000820.initial_effect(c)
c:EnableCounterPermit(0x88)
 aux.AddOrigPandemoniumType(c)
--If this card is activated: You can add 1 "Medivatale" card from your Deck or GY to your hand. You can destroy this card, and if you do, all Evolute Monsters you control gain 4 E-C. You can only use each effect of "Medivatale Tortoise" once per turn.
 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetDescription(aux.Stringid(16000820,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,16000820)
	e1:SetCondition(aux.PandActCheck)
	e1:SetTarget(c16000820.target)
	e1:SetOperation(c16000820.activate)
	c:RegisterEffect(e1)
	aux.EnablePandemoniumAttribute(c,e1) 
	  --Evolute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16000820,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,16000821)
	e2:SetTarget(c16000820.thtg)
	e2:SetOperation(c16000820.thop)
	c:RegisterEffect(e2)
--special summon
--  local e3=Effect.CreateEffect(c)
--  e3:SetDescription(aux.Stringid(16000820,2))
--  e3:SetType(EFFECT_TYPE_FIELD)
--  e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
--  e3:SetCode(EFFECT_SPSUMMON_PROC)
--  e3:SetRange(LOCATION_HAND)
--  e3:SetCountLimit(1,16000822)
--  e3:SetCondition(c16000820.sprcon)
--  c:RegisterEffect(e3) 
	--  local e4=e3:Clone()
--  e4:SetCondition(c16000820.sprcon2)
	--c:RegisterEffect(e4)
	 --hand 
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_EXTRA_EVOLUTE_MATERIAL)
	e5:SetRange(LOCATION_HAND)
	e5:SetCondition(c16000820.matcon)
	--e1:SetValue(c16000820.matval)
	e5:SetOperation(ref.matop)
	c:RegisterEffect(e5)
	 --become material
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EVENT_BE_MATERIAL)
	e6:SetCondition(c16000820.condition2)
	e6:SetOperation(c16000820.operation2)
	c:RegisterEffect(e6)
end
function c16000820.filter(c)
	return c:IsSetCard(0xab5) and c:IsAbleToHand()
end
function c16000820.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():GetFlagEffect(16000820)==0 and Duel.IsExistingMatchingCard(c16000820.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	c:RegisterFlagEffect(16000820,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c16000820.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c16000820.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c16000820.xfilter(c)
	return c:IsType(TYPE_EVOLUTE) and c:IsFaceup() 
end

function c16000820.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() and Duel.IsExistingMatchingCard(ref.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end

function c16000820.thop(e,tp,eg,ep,ev,re,r,rp)
 local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	local g=Duel.GetMatchingGroup(c16000820.xfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
	 
   tc:AddEC(4)
		tc=g:GetNext()
	end
end
function c16000820.cfilter(c)
	return c:IsFaceup() and ( c:GetSummonLocation()==LOCATION_EXTRA  and c:IsType(TYPE_EFFECT))
end
function c16000820.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and  not Duel.IsExistingMatchingCard(c16000820.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c16000820.cfilter2(c)
	return c:IsFaceup() and c:GetSummonLocation()==LOCATION_EXTRA and  c:IsSetCard(0xab5)
end
function c16000820.sprcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and  Duel.IsExistingMatchingCard(c16000820.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c16000820.matcon(c,ec,mode)
	if mode==1 then return Duel.GetFlagEffect(c:GetControler(),16000820)==0 and c:IsLocation(LOCATION_HAND) end
	return true
end
function c16000820.mfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xab5)
end
function c16000820.matval(e,c,mg)
	return  mg:IsExists(c16000820.mfilter,1,nil)
end
function ref.matop(c)
	Duel.SendtoGrave(c,REASON_MATERIAL+0x10000000)
end
function c16000820.ffilter(c)
	return c:IsRace(RACE_FAIRY)
end

function c16000820.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetReasonCard()
	return ec:GetMaterial():IsExists(c16000820.ffilter,1,nil) and  r==REASON_EVOLUTE ~=0
end
function c16000820.operation2(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetFlagEffect(tp,16000820)~=0 then return end
	Duel.Hint(HINT_CARD,0,16000820) 
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(16000820,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_MZONE)
   e1:SetCondition(c16000820.spcon)
	e1:SetTarget(c16000820.sptg)
	e1:SetOperation(c16000820.spop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_ADD_TYPE)
		e0:SetValue(TYPE_EFFECT)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e0,true)
	rc:RegisterFlagEffect(16000820,RESET_EVENT+RESETS_STANDARD+0x47e0000,0,1)
	end
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(16000820,3))
	Duel.RegisterFlagEffect(tp,16000820,RESET_PHASE+PHASE_END,0,1)
end
function c16000820.cfilter2(c,tp,zone)
return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and bit.band(c:GetPreviousRaceOnField(),RACE_FAIRY)~=0
		and  (c:IsReason(REASON_BATTLE) or (rp~=tp and c:IsReason(REASON_EFFECT)))
end
function c16000820.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c16000820.cfilter2,1,nil,tp,rp)
end
function c16000820.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c16000820.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16000820.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c16000820.spop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	   local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c16000820.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if ft<1 or g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
	if ft>1 and g:GetCount()>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.SelectYesNo(tp,aux.Stringid(16000820,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g:Select(tp,1,1,nil)
		sg:AddCard(sg2:GetFirst())
	end
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
		c:RemoveEC(tp,2,REASON_EFFECT)
	end
end
