--CXyz Zexal III
function c249000357.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(c249000357.matfilter),4,3,c249000357.ovfilter,aux.Stringid(249000357,1))
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(249000357,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c249000357.target)
	e1:SetOperation(c249000357.operation)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c249000357.sumsuc)
	c:RegisterEffect(e2)
end
function c249000357.matfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c249000357.ovfilter(c)
	return c:IsFaceup() and c:IsCode(249000193)
end
function c249000357.filter1(c)
	return (c:IsSetCard(0x48) or c:IsSetCard(0x107F)) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000357.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE+LOATION_GRAVE) and c249000357.filter1(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c249000357.filter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c249000357.filter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000357.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if (tc:IsFacedown() and not tc:IsLocation(LOCATION_GRAVE)) or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	local c=e:GetHandler()
	local t={}
	local i=1
	local p=1
	for i=0,4 do 
		if Duel.CheckLocation(tp,LOCATION_MZONE,i) then t[p]=i p=p+1 end
	end
	t[p]=nil
	local seq=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.MoveSequence(c,seq)
	local rk=tc:GetRank()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ac=Duel.AnnounceCardFilter(tp,0x48,OPCODE_ISSETCARD)
	sc=Duel.CreateToken(tp,ac)
	while not (sc:IsType(TYPE_XYZ) and sc:IsSetCard(0x48)
	and (sc:GetRank() == rk +1 or sc:GetRank() == rk +2 or sc:GetRank() == rk +3)
	and sc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false))
	do
		ac=Duel.AnnounceCardFilter(tp,0x48,OPCODE_ISSETCARD,OPCODE_AND,OPCODE_ISTYPE,TYPE_XYZ)
		sc=Duel.CreateToken(tp,ac)
		if sc:IsType(TYPE_TRAP) then return end
	end
	Duel.SendtoDeck(sc,nil,0,REASON_RULE)
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP)
		if c:GetOverlayGroup():GetCount()>0 then
			Duel.BreakEffect()
			local g1=c:GetOverlayGroup()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47660516,0))
			local mg2=g1:Select(tp,1,1,nil)
			local oc=mg2:GetFirst()
			Duel.Overlay(sc,mg2)
			Duel.RaiseSingleEvent(oc,EVENT_DETACH_MATERIAL,e,0,0,0,0)
		end
		sc:CompleteProcedure()
		if Duel.GetLP(tp) > 3000 then
			Duel.SetLP(tp,Duel.GetLP(tp)-1500)
		end
	end
end
function c249000357.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLP(tp) >= 3000 then return end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetTarget(c249000357.tg)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
	local e1=e2:Clone()
	e1:SetValue(aux.tgoval)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	Duel.RegisterEffect(e1,tp)
end
function c249000357.tg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end