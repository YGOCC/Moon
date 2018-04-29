--Rank-Up-Magic Numeral Force
function c249000400.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c249000400.cost)
	e1:SetTarget(c249000400.target)
	e1:SetOperation(c249000400.activate)
	c:RegisterEffect(e1)
	--move zone
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c249000400.seqtg)
	e2:SetOperation(c249000400.seqop)
	c:RegisterEffect(e2)
end
function c249000400.costfilter(c)
	return c:IsSetCard(0x1B9) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c249000400.costfilter2(c,e)
	return c:IsSetCard(0x1B9) and c:IsType(TYPE_MONSTER) and not c:IsPublic() and c~=e:GetHandler()
end
function c249000400.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000400.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000400.costfilter2,tp,LOCATION_HAND,0,1,nil,e)) end
	local option
	if Duel.IsExistingMatchingCard(c249000400.costfilter2,tp,LOCATION_HAND,0,1,nil,e)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000400.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000400.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000400.costfilter2,tp,LOCATION_HAND,0,1,nil,e) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000400.costfilter2,tp,LOCATION_HAND,0,1,1,nil,e)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000400.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000400.filter1(c,e,tp)
	local rk=c:GetRank()
	return rk>0 and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c249000400.filter2,tp,LOCATION_EXTRA,0,1,nil,rk+2,c:GetCode(),e,tp)
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c249000400.filter2(c,rk,code,e,tp)
	if c:IsCode(6165656) and code~=48995978 then return false end
	return c:IsSetCard(0x48) and (c:GetRank()==rk or c:GetRank()==rk-1) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c249000400.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c249000400.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c249000400.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c249000400.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000400.numtablematch(num)
	for i=1,25 do
		if c249000400.missing_number_table[i]==num then return true end
	end
	return false
end
function c249000400.activate(e,tp,eg,ep,ev,re,r,rp)
	local num=math.random(0,107)
	while c249000400.numtablematch(num) do num=math.random(0,107) end
	local a1=Duel.AnnounceNumber(tp,num)
	local ac=Duel.AnnounceCardFilter(tp,0x48,OPCODE_ISSETCARD)
	local token=Duel.CreateToken(tp,ac)
	while not (token.xyz_number==a1)
		do
			ac=Duel.AnnounceCardFilter(tp,0x48,OPCODE_ISSETCARD)
			token=Duel.CreateToken(tp,ac)
		end
	Duel.SendtoDeck(token,nil,0,REASON_RULE)
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c249000400.filter2,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetRank()+2,tc:GetCode(),e,tp)
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
	end
end
function c249000400.seqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c249000400.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c249000400.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000400.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(92204263,1))
	Duel.SelectTarget(tp,c249000400.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c249000400.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,571)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end
c249000400.missing_number_table={
1,2,3,4,24,26,27,28,60,76,97
}