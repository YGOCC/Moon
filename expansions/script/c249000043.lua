--Elven Counter Summoner
function c249000043.initial_effect(c)
	c:EnableCounterPermit(0x25)
	--add counter spell activation
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c249000043.acop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c249000043.sptg)
	e2:SetOperation(c249000043.spop)
	c:RegisterEffect(e2)
	--add counter standby phase
	local e3=Effect.CreateEffect(c)	
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c249000043.acop2)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetCountLimit(2)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c249000043.reptg)
	c:RegisterEffect(e4)
	--add counter summon success
	local e5=Effect.CreateEffect(c)	
	e5:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetOperation(c249000043.acop2)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)	
end
function c249000043.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) then
		e:GetHandler():AddCounter(0x25,2)
	end
end
function c249000043.filter(c,cc,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()>0 and cc:IsCanRemoveCounter(tp,0x25,c:GetLevel(),REASON_COST) 
			and cc:IsCanRemoveCounter(tp,0x25,3,REASON_COST)
end
function c249000043.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000043.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e:GetHandler(),e,tp) end
	local g=Duel.GetMatchingGroup(c249000043.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e:GetHandler(),e,tp)
	local lvt={}
	local tc=g:GetFirst()
	while tc do
		local tlv=tc:GetLevel()
		lvt[tlv]=tlv
		tc=g:GetNext()
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(249000043,1))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	if lv<=2 then
		e:GetHandler():RemoveCounter(tp,0x25,2,REASON_COST)
	else
		e:GetHandler():RemoveCounter(tp,0x25,lv,REASON_COST)
	end
	
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c249000043.sfilter(c,lv,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()==lv
end
function c249000043.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c249000043.sfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,lv,e,tp)
	if g:GetCount()>0 and g:GetFirst():IsCanAddCounter(0x25,1) then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	else
		local c=e:GetHandler()
		local tc=g:GetFirst()
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
		end
	end
end
function c249000043.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and e:GetHandler():IsCanRemoveCounter(tp,0x25,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x25,1,REASON_EFFECT)
	return true
end
function c249000043.acop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x25,2)
end