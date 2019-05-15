--Xyz-Magician Dark Angel
function c249000274.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c249000274.spcon)
	e1:SetTarget(c249000274.sptg)
	e1:SetOperation(c249000274.spop)
	c:RegisterEffect(e1)
	--change level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c249000274.target)
	e2:SetOperation(c249000274.operation)
	c:RegisterEffect(e2)
	--special summon 2
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--special summon self
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c249000274.spcon2)
	c:RegisterEffect(e4)
end
function c249000274.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c249000274.filter(c,e,tp)
	return c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c249000274.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000274.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c249000274.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,c249000274.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		if not tc:IsSetCard(0x2073) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end
function c249000274.filter2(c)
	return c:IsFaceup() and c:IsLevelAbove(0) and c:IsSetCard(0x2073)
end
function c249000274.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c249000274.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000274.filter2,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c249000274.filter2,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
	if g:GetFirst():GetLevel()==e:GetHandler():GetLevel() then
	local lv
		lv=Duel.AnnounceLevel(tp,1,8,g:GetFirst():GetLevel())
	else
		lv=Duel.AnnounceLevel(tp,1,8)
	end
	e:SetLabel(lv)
end
function c249000274.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetValue(e:GetLabel())
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_TOMAIN_KOISHI)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_XYZ))
	Duel.RegisterEffect(e3,tp)
end
function c249000274.spcon2(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil)-Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)>=2
end