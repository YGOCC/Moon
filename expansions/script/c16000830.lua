--Medivatale Bunny
function c16000830.initial_effect(c)
  --special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,16000830)
	e0:SetCondition(c16000830.sprcon)
	c:RegisterEffect(e0) 
	   local e1=e0:Clone()
	e1:SetCondition(c16000830.sprcon2)
	c:RegisterEffect(e1)
--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	--e2:SetCountLimit(1,16000830)
	e2:SetTarget(c16000830.sptg)
	e2:SetOperation(c16000830.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--become material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(c16000830.condition2)
	e5:SetOperation(c16000830.operation2)
	c:RegisterEffect(e5)
end
function c16000830.cfilter(c)
	return c:IsFaceup() and  c:GetSummonLocation()==LOCATION_EXTRA  and c:IsType(TYPE_EFFECT)
end
function c16000830.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and  not Duel.IsExistingMatchingCard(c16000830.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c16000830.cfilter2(c)
	return c:IsFaceup() and c:GetSummonLocation()==LOCATION_EXTRA and  c:IsSetCard(0xab5)
end
function c16000830.sprcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and  Duel.IsExistingMatchingCard(c16000830.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c16000830.setfilter(c)
	return (c:IsSetCard(0xab5) and c:GetType()&TYPE_PANDEMONIUM==TYPE_PANDEMONIUM )or (c:IsSetCard(0xab5) and c:IsType(TYPE_SPELL+TYPE_TRAP))
end
function c16000830.spcheck(c)
	return c:GetType()&TYPE_PANDEMONIUM==TYPE_PANDEMONIUM and c:IsFaceup()
end

function c16000830.setfilter2(c)
	return c:IsSetCard(0xab5) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end


function c16000830.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c16000830.setfilter,tp,LOCATION_DECK,0,1,nil)
	end
end
function c16000830.spop(e,tp,eg,ep,ev,re,r,rp)
	  if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c16000830.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if g then
		Card.SetCardData(g,CARDDATA_TYPE,TYPE_TRAP+TYPE_CONTINUOUS)
		Duel.SSet(tp,g)
		Duel.ConfirmCards(1-tp,g)
		if not g:IsLocation(LOCATION_SZONE) then
			if g:GetOriginalType()==TYPE_MONSTER+TYPE_EFFECT then
				Card.SetCardData(g,CARDDATA_TYPE,TYPE_MONSTER+TYPE_EFFECT)
			elseif g:GetOriginalType()==TYPE_MONSTER+TYPE_EFFECT+TYPE_TUNER or g:GetOriginalType()==TYPE_MONSTER+TYPE_TUNER then
				Card.SetCardData(g,CARDDATA_TYPE,TYPE_MONSTER+TYPE_EFFECT+TYPE_TUNER)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:RegisterEffect(e1)
			end
		end
	end
end


function c16000830.activate(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c16000830.setfilter2,tp,LOCATION_DECK,0,1,1,nil,false)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
			Duel.ConfirmCards(1-tp,g)
local c=e:GetHandler()
	  local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:RegisterEffect(e1)
	end
end


function c16000830.ffilter(c)
	return c:IsRace(RACE_FAIRY)
end
function c16000830.splimit(e,c)
	return c:GetRace()~=RACE_FAIRY or c:GetAttribute()~=ATTRIBUTE_DARK 
end
function c16000830.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetReasonCard()
	return ec:GetMaterial():IsExists(c16000830.ffilter,1,nil) and r&(REASON_SUMMON+REASON_FUSION+REASON_SYNCHRO+REASON_RITUAL+REASON_XYZ+REASON_LINK)==0
end
function c16000830.operation2(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetFlagEffect(tp,16000830)~=0 then return end
	Duel.Hint(HINT_CARD,0,16000830) 
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(16000830,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCountLimit(1,16000830)
	e1:SetCost(c16000830.cost)
	e1:SetTarget(c16000830.target)
	e1:SetOperation(c16000830.operation)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	rc:RegisterFlagEffect(16000830,RESET_EVENT+RESETS_STANDARD+0x47e0000,0,1)
	end
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(16000830,0))
	Duel.RegisterFlagEffect(tp,16000830,RESET_PHASE+PHASE_END,0,1)
end
function c16000830.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,3,REASON_COST) end
	e:GetHandler():IsCanRemoveEC(tp,3,REASON_COST)
end
function c16000830.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c16000830.fukfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
end
function c16000830.fukfilter(c)
	return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_EFFECT)
end
function c16000830.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c16000830.fukfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
