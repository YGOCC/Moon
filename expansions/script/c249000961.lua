--Rank-Up-Magic Shining Path
function c249000961.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_DESTROY+TIMING_END_PHASE)
	e1:SetCondition(c249000961.condition)
	e1:SetTarget(c249000961.target)
	e1:SetOperation(c249000961.activate)
	c:RegisterEffect(e1)
	if not c249000961.globle_check then
		c249000961.globle_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c249000961.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c249000961.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsReason(REASON_DESTROY) then
			if tc:GetPreviousControler()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,249000961,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,249000961,RESET_PHASE+PHASE_END,0,1) end
end
function c249000961.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,249000961)~=0
end
function c249000961.filter1(c,e,tp)
	local m=_G["c"..c:GetCode()]
	if not m or m.xyz_number==nil then return false end
	return c:IsSetCard(0x48)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c249000961.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank(),m.xyz_number,c:GetCode())
end
function c249000961.filter2(c,e,tp,mc,rk,no,code)
	local m=_G["c"..c:GetCode()]
	if not m or m.xyz_number==nil then return false end
	return rk > 1 and (c:IsRank(rk) or c:IsRank(rk+1)) and c:IsSetCard(0x48) and mc:IsCanBeXyzMaterial(c)
	and m.xyz_number==no and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:GetCode()~=code
end
function c249000961.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c249000961.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingTarget(c249000961.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c249000961.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_EXTRA)
end
function c249000961.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local m=_G["c"..tc:GetCode()]
	if not m or m.xyz_number==nil then return end
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 or not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c249000961.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank(),m.xyz_number,tc:GetCode())
	local sc=g:GetFirst()
	if sc then
		sc:SetMaterial(Group.FromCards(tc))
		local og=Group.FromCards(tc)
		if c:IsRelateToEffect(e) then
			og:AddCard(c)
			c:CancelToGrave()
		end
		Duel.Overlay(sc,og)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		--Cost Change
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_LPCOST_CHANGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetTargetRange(1,0)
		e1:SetValue(c249000961.costchange)
		sc:RegisterEffect(e1)
	end
end
function c249000961.costchange(e,re,rp,val)
	if re and re:IsHasType(0x7e0) and re:GetHandler()==e:GetHandler() then
		return 0
	else return val end
end