--Star Shaper Elf
function c249000726.initial_effect(c)
	--level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,2490007261)
	e1:SetCost(c249000726.cost)
	e1:SetTarget(c249000726.target)
	e1:SetOperation(c249000726.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11674673,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,2490007262)
	e2:SetCondition(c249000726.spcon)
	e2:SetTarget(c249000726.sptg)
	e2:SetOperation(c249000726.spop)
	c:RegisterEffect(e2)
end
function c249000726.costfilter(c)
	return c:IsSetCard(0x1EB) and c:IsAbleToRemoveAsCost()
end
function c249000726.costfilter2(c)
	return c:IsSetCard(0x1EB) and not c:IsPublic()
end
function c249000726.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000726.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000726.costfilter2,tp,LOCATION_HAND,0,1,nil)) end
	local option
	if Duel.IsExistingMatchingCard(c249000726.costfilter2,tp,LOCATION_HAND,0,1,nil)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000726.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000726.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000726.costfilter2,tp,LOCATION_HAND,0,1,nil) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000726.costfilter2,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000726.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000726.filter1(c)
	return c:IsLevelAbove(1) and not c:IsType(TYPE_FUSION)
end
function c249000726.filter2(c,code)
	return c:IsLevelAbove(1) and c:GetCode()==code
end
function c249000726.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000726.filter1,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) end
end
function c249000726.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,249000726,RESET_PHASE+PHASE_END,0,1)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,c249000726.filter1,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc==nil then return end
	Duel.ConfirmCards(1-tp,tc)
	local code=tc:GetCode()
	local lv=Duel.AnnounceNumber(tp,1,2,3)	
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_EXTRA,0):Filter(c249000726.filter2,nil,code)
	local tc2=hg:GetFirst()
	while tc2 do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		tc2:RegisterEffect(e1)
		tc2=hg:GetNext()
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabel(lv)
	e2:SetLabelObject(tc)
	e2:SetOperation(c249000726.hlvop)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_DECK)	
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_RANK)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_XYZ))
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetValue(lv)
	Duel.RegisterEffect(e4,tp)	
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CHANGE_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(0,1)
	e5:SetLabel(1-tp)
	e5:SetValue(c249000726.damval)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
end
function c249000726.hlvfilter(c,tp,code)
	return c:IsLevelAbove(1) and c:IsControler(tp) and c:GetCode()==code and c:IsLocation(LOCATION_HAND+LOCATION_EXTRA)
end
function c249000726.hlvop(e,tp,eg,ep,ev,re,r,rp)
	local hg=eg:Filter(c249000726.hlvfilter,nil,tp,e:GetLabelObject():GetCode())
	local tc=hg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=hg:GetNext()
	end
end
function c249000726.damval(e,re,val,r,rp,rc)
	if Duel.GetFieldGroupCount(e:GetLabel(),LOCATION_MZONE,0,nil)==0 then return val/2 else return val end
end
function c249000726.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,249000726)>0
end
function c249000726.filter3(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c249000726.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000726.filter3,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c249000726.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c249000726.filter3),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end