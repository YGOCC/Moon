--Oltrepassamento Limite della Xenofiamma
--Script by XGlitchy30
function c26591139.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26591139)
	e1:SetTarget(c26591139.target)
	e1:SetOperation(c26591139.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26591139,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c26591139.sptg)
	e2:SetOperation(c26591139.spop)
	c:RegisterEffect(e2)
end
--filters
function c26591139.spfilter(c,e,tp,mc)
	return c:IsSetCard(0x23b9) and bit.band(c:GetType(),0x81)==0x81 and (not c.mat_filter or c.mat_filter(mc))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		and mc:IsCanBeRitualMaterial(c)
end
function c26591139.rfilter(c,mc)
	local mlv=mc:GetRitualLevel(c)
	if mlv==mc:GetLevel() then return false end
	local lv=c:GetLevel()
	return lv==bit.band(mlv,0xffff) or lv==bit.rshift(mlv,16)
end
function c26591139.filter(c,e,tp)
	local sg=Duel.GetMatchingGroup(c26591139.spfilter,tp,LOCATION_HAND,0,c,e,tp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if c:IsLocation(LOCATION_MZONE) then ft=ft+1 end
	if Duel.IsPlayerAffectedByEffect(tp,26591139) then ft=1 end
	return sg:IsExists(c26591139.rfilter,1,nil,c) or sg:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,ft)
end
function c26591139.mfilter(c)
	return c:GetLevel()>0
end
function c26591139.mzfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:GetSequence()<5
end
function c26591139.remfilter(c)
	return c:GetLevel()>0 and c:IsSetCard(0x23b9) and c:IsAbleToRemove()
end
function c26591139.cfilter(c,e,tp,m)
	if not c:IsSetCard(0x23b9) or bit.band(c:GetType(),0x81)~=0x81 or c:IsCode(26591136)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil)
	end
	return --m:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
	m:IsExists(c26591139.lv1,1,nil,m,c:GetLevel())
end
function c26591139.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) then
		Duel.SetSelectedCard(c)
		return --mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
		mg:IsExists(c26591139.lv1,1,nil,mg,c:GetLevel()) 
	else return false end
end
function c26591139.lv1(c,m,lv)
	return c:GetLevel()>0 and m:IsExists(c26591139.lv2,1,c,lv,c:GetLevel())
end
function c26591139.lv2(c,lv,mlv)
	return c:GetLevel()>0 and c:GetLevel()>=math.abs(lv-mlv)
end
--Activate
function c26591139.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<0 then return false end
		local mg=Duel.GetRitualMaterial(tp)
		if ft>0 then
			local mg2=Duel.GetMatchingGroup(c26591139.mfilter,tp,LOCATION_EXTRA,0,nil)
			mg:Merge(mg2)
		else
			mg=mg:Filter(c26591139.mzfilter,nil,tp)
		end
		return mg:IsExists(c26591139.filter,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c26591139.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<0 then return end
	local mg=Duel.GetRitualMaterial(tp)
	if ft>0 then
		local mg2=Duel.GetMatchingGroup(c26591139.mfilter,tp,LOCATION_EXTRA,0,nil)
		mg:Merge(mg2)
	else
		mg=mg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mat=mg:FilterSelect(tp,c26591139.filter,1,1,nil,e,tp)
	local mc=mat:GetFirst()
	if not mc then return end
	local sg=Duel.GetMatchingGroup(c26591139.spfilter,tp,LOCATION_HAND,0,mc,e,tp,mc)
	if mc:IsLocation(LOCATION_MZONE) then ft=ft+1 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local b1=sg:IsExists(c26591139.rfilter,1,nil,mc)
	local b2=sg:CheckWithSumEqual(Card.GetLevel,mc:GetLevel(),1,ft)
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(26591139,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:FilterSelect(tp,c26591139.rfilter,1,1,nil,mc)
		local tc=tg:GetFirst()
		tc:SetMaterial(mat)
		if not mc:IsLocation(LOCATION_EXTRA) then
			Duel.ReleaseRitualMaterial(mat)
		else
			Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:SelectWithSumEqual(tp,Card.GetLevel,mc:GetLevel(),1,ft)
		local tc=tg:GetFirst()
		while tc do
			tc:SetMaterial(mat)
			tc=tg:GetNext()
		end
		if not mc:IsLocation(LOCATION_EXTRA) then
			Duel.ReleaseRitualMaterial(mat)
		else
			Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		Duel.BreakEffect()
		tc=tg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
			tc=tg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
--spsummon
function c26591139.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c26591139.remfilter,tp,LOCATION_GRAVE,0,nil)
		mg:RemoveCard(e:GetHandler())
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return ft>0 and Duel.IsExistingMatchingCard(c26591139.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c26591139.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c26591139.remfilter,tp,LOCATION_GRAVE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c26591139.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg,ft)
	local tc=tg:GetFirst()
	if tc then
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		local mat1=nil
		local mat2=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		--mat1=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc,2,2)
		mat1=mg:FilterSelect(tp,c26591139.lv1,1,1,nil,mg,tc:GetLevel())
		mat2=mg:FilterSelect(tp,c26591139.lv2,1,1,mat1:GetFirst(),tc:GetLevel(),mat1:GetFirst():GetLevel())
		mat1:Merge(mat2)
		tc:SetMaterial(mat1)
		Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end