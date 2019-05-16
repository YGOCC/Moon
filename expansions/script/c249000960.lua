--Rank-Up-Magic Shining Evoltion
function c249000960.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c249000960.target)
	e1:SetOperation(c249000960.activate)
	c:RegisterEffect(e1)
end
function c249000960.filter1(c,e,tp)
	local m=_G["c"..c:GetCode()]
	if not m or m.xyz_number==nil then return false end
	return c:IsFaceup() and c:IsSetCard(0x48) and m
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c249000960.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank(),m.xyz_number,c:GetCode())
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c249000960.filter2(c,e,tp,mc,rk,no,code)
	local m=_G["c"..c:GetCode()]
	if not m or m.xyz_number==nil then return false end
	return rk > 1 and (c:IsRank(rk) or c:IsRank(rk+1)) and c:IsSetCard(0x48) and m.xyz_number==no and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:GetCode()~=code
end
function c249000960.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c249000960.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c249000960.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c249000960.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000960.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local m=_G["c"..tc:GetCode()]
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 or not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL)
		or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or not m then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c249000960.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank(),m.xyz_number,tc:GetCode())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		--Cost Change
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_LPCOST_CHANGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetTargetRange(1,0)
		e1:SetValue(c249000960.costchange)
		sc:RegisterEffect(e1)
	end
end
function c249000960.costchange(e,re,rp,val)
	if re and re:IsHasType(0x7e0) and re:GetHandler()==e:GetHandler() then
		return 0
	else return val end
end