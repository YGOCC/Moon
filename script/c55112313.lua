--Cubigon
function c55112313.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55112313,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c55112313.sptg)
	e1:SetOperation(c55112313.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--ATK gain on equip
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(function(e) local ec=e:GetHandler():GetEquipTarget() return ec:IsRace(RACE_DRAGON) and ec.bigbang end)
	e4:SetValue(function(e,c) local ec=e:GetHandler():GetEquipTarget() return ec:GetEquipGroup():FilterCount(c55112313.atkfilter,nil)*500 end)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
end
function c55112313.atkfilter(c)
	return bit.band(c:GetOriginalType(),TYPE_MONSTER+TYPE_CONTINUOUS)~=0
end
function c55112313.filter(c,e,tp)
	return (c:IsCode(52471658) or c:IsCode(40444917) or c:IsCode(54900205)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c55112313.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c55112313.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c55112313.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55112313.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local c=e:GetHandler()
	local op=0
	if c:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(55112313,1))
		else op=Duel.SelectOption(tp,aux.Stringid(55112313,1),aux.Stringid(55112313,2)) end
	e:SetLabel(op)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else e1:SetValue(-1) end
		if c:RegisterEffect(e1) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetTargetRange(1,0)
			e2:SetTarget(c55112313.splimit)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function c55112313.splimit(e,c)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end