--Paintress Vincamistress
function c16001000.initial_effect(c)
	   aux.AddOrigEvoluteType(c)
  aux.AddEvoluteProc(c,nil,9,c16001000.filter1,c16001000.filter2,3,99)

  local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(16001000,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_LEAVE_FIELD)
	 e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
   e1:SetCondition(c16001000.spcon)
	e1:SetTarget(c16001000.sptg)
	e1:SetOperation(c16001000.spop)
	c:RegisterEffect(e1)
		  --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16001000,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCondition(c16001000.drcon)
	e3:SetCost(c16001000.pscost)
	e3:SetTarget(c16001000.pstg)
	e3:SetOperation(c16001000.psop)
	c:RegisterEffect(e3)
--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetCondition(c16001000.immcon)
	e4:SetValue(c16001000.efilter)
	c:RegisterEffect(e4)
end

function c16001000.filter1(c,ec,tp)
	return c:IsRace(RACE_FAIRY) or c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c16001000.filter2(c,ec,tp)
	return c:IsRace(RACE_FAIRY) or c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c16001000.cfilter2(c,tp,zone) 
return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsSetCard(0xc50)
	  
end
function c16001000.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c16001000.cfilter2,1,nil,tp,rp)
end
function c16001000.spfilter(c,e,tp)
	return c:IsSetCard(0xc50) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c16001000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16001000.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c16001000.spop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()

if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16001000.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,0,tp,false,false)
	if g:GetCount()>0 then
		 Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
c:AddEC(4)
	end
end

function c16001000.pscost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,8,REASON_COST)  end
	 e:GetHandler():RemoveEC(tp,8,REASON_COST)
end
function c16001000.rmfilter(c,p)
	return Duel.IsPlayerCanRemove(p,c) and  c:IsType(TYPE_EFFECT)
end
function c16001000.psfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc50) and c:IsType(TYPE_PENDULUM) 
end

function c16001000.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  Duel.IsExistingMatchingCard(c16001000.psfilter,tp,LOCATION_EXTRA,0,1,nil)
end
function c16001000.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)

	--Debug.Message(g:GetCount())
	--Debug.Message(Duel.GetMatchingGroupCount(c16001000.psfilter,tp,LOCATION_EXTRA,0,nil))

	local ct=(g:GetCount()-Duel.GetMatchingGroupCount(c16001000.psfilter,tp,LOCATION_EXTRA,0,nil))

   -- Debug.Message(ct)
   -- if e:GetHandler():IsLocation(LOCATION_HAND) then ct=ct-1 end
	if chk==0 then return true end--not Duel.IsPlayerAffectedByEffect(1-tp,4130270) and ct>0 and g:IsExists(c16001000.rmfilter,1,nil,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,ct,0,0)
end
function c16001000.psop(e,tp,eg,ep,ev,re,r,rp)
	--if Duel.IsPlayerAffectedByEffect(1-tp,4130270) then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local ct=(g:GetCount()-Duel.GetMatchingGroupCount(c16001000.psfilter,tp,LOCATION_EXTRA,0,nil))
	--Debug.Message("should now remove this many cards:")
	--Debug.Message(ct)
	--if ct>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=Duel.SelectMatchingCard(1-tp,c16001000.rmfilter,tp,0,LOCATION_ONFIELD,ct,ct,nil,1-tp)	
--g:FilterSelect(1-tp,c16001000.rmfilter,ct,ct,nil,1-tp)
		Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)
	--end
end
function c16001000.immcon(e)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c16001000.efilter(e,te)
	return te:IsActiveType(EFFECT_TYPE_ACTIVATE) and te:GetOwner()~=e:GetOwner()
end


