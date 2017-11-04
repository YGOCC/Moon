--Feluna
--Design and Code by Kindrindra--
local ref=_G['c'..28915313]
function ref.initial_effect(c)
	--Summon Other
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28915313,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)--+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(ref.sptg)
	e1:SetOperation(ref.spop)
	c:RegisterEffect(e1)
	--Fusion
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28915313,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(ref.target)
	e2:SetOperation(ref.operation)
	c:RegisterEffect(e2)
	--Revive
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,28915313)
	e4:SetCondition(ref.sscon)
	e4:SetCost(ref.sscost)
	e4:SetTarget(ref.sstg)
	e4:SetOperation(ref.ssop)
	c:RegisterEffect(e4)
end

function ref.spfilter(c,e,tp)
	local lv=c:GetLevel()
	return c:IsSetCard(0x72C) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(ref.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,ref.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		--Duel.Draw(tp,1,REASON_EFFECT)
	end
end

function ref.filter1(c,e)
	return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function ref.filter2(c,e,tp,m,f,gc)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,c)
		local res=Duel.IsExistingMatchingCard(ref.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(ref.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,c)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	local mg1=Duel.GetFusionMaterial(tp):Filter(ref.filter1,c,e)
	local sg1=Duel.GetMatchingGroup(ref.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(ref.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,c)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,c)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end

function ref.sscfilter(c)
	return c:IsSetCard(0x72D) and c:IsType(TYPE_MONSTER)
end
function ref.sscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(ref.sscfilter,1,nil)
end
function ref.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost()
		and Duel.IsExistingTarget(ref.ssfilter,tp,LOCATION_GRAVE,0,1,c,e,tp)
	end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
end
function ref.ssfilter(c,e,tp)
	return c:IsSetCard(0x72C) and c:IsRace(RACE_BEAST)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.sstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(ref.ssfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,ref.ssfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function ref.ssop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
