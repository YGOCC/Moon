--Disegnacieli Variopinta
--Script by XGlitchy30
function c86433593.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--counter permit/limit
	c:EnableCounterPermit(0x335,LOCATION_PZONE+LOCATION_MZONE)
	c:SetCounterLimit(0x335,7)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c86433593.ctcon)
	e1:SetOperation(c86433593.ctop)
	c:RegisterEffect(e1)
	--change level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(86433593,0))
	e2:SetCategory(CATEGORY_LVCHANGE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c86433593.lvtg)
	e2:SetOperation(c86433593.lvop)
	c:RegisterEffect(e2)
end
--filters
function c86433593.ctfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY)
end
function c86433593.filter(c,cc,tp,lv)
	local ct=c:GetLevel()
	local check=0
	if not lv then
		for i=1,7 do
			if cc:IsCanRemoveCounter(tp,0x335,i,REASON_COST) then
				if i~=ct then
					check=1
				end
			end
		end
	end
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and c:GetLevel()>0 and ((not lv and check>0) or ct~=lv)
end
--add counter
function c86433593.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c86433593.ctfilter,1,nil)
end
function c86433593.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c86433593.ctfilter,nil)
	e:GetHandler():AddCounter(0x335,ct,1)
end
--change level
function c86433593.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c86433593.filter(chkc,e:GetHandler(),tp,nil) end
	if chk==0 then return Duel.IsExistingTarget(c86433593.filter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler(),tp,nil) end
	local g=Duel.GetMatchingGroup(c86433593.filter,tp,LOCATION_MZONE,0,nil,e:GetHandler(),tp,nil)
	local lvt={}
	local tab={}
	local tc=g:GetFirst()
	while tc do
		local tlv=tc:GetLevel()
		lvt[tlv]=tlv
		tc=g:GetNext()
	end
	for i=1,7 do
		if not lvt[i] and e:GetHandler():IsCanRemoveCounter(tp,0x335,i,REASON_COST) then
			table.insert(tab,i)
		else
			local ct=0
			for i2=1,7 do
				if lvt[i2] and e:GetHandler():IsCanRemoveCounter(tp,0x335,i2,REASON_COST) then
					ct=ct+1
				end
			end
			if ct>1 then
				table.insert(tab,i)
			end
		end
	end
	local lv=Duel.AnnounceNumber(tp,table.unpack(tab))
	local ogct=e:GetHandler():GetCounter(0x335)
	e:GetHandler():RemoveCounter(tp,0x335,lv,REASON_COST)
	local newct=e:GetHandler():GetCounter(0x335)
	e:SetLabel(math.abs(ogct-newct))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c86433593.filter,tp,LOCATION_MZONE,0,1,1,nil,e:GetHandler(),tp,lv)
	if e:GetLabel()==7 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	end
end
function c86433593.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lv=e:GetLabel()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if lv==7 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
			if Duel.SelectYesNo(tp,aux.Stringid(86433593,1)) then
				Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end