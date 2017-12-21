function c500315978.initial_effect(c)
	
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(500315978,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,500315978)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c500315978.cost)
	e3:SetTarget(c500315978.target)
	e3:SetOperation(c500315978.operation)
	c:RegisterEffect(e3)

end
function c500315978.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c500315978.spfilter(c,e,tp,mc)
	return c:IsSetCard(0x185a) and bit.band(c:GetType(),0x81)==0x81 and (not c.mat_filter or c.mat_filter(mc))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		and mc:IsCanBeRitualMaterial(c)
end
function c500315978.rfilter(c,mc)
	local mlv=mc:GetRitualLevel(c)
	if mlv==mc:GetLevel() then return false end
	local lv=c:GetLevel()
	return lv==bit.band(mlv,0xffff) or lv==bit.rshift(mlv,16)
end
function c500315978.filter(c,e,tp)
	local sg=Duel.GetMatchingGroup(c500315978.spfilter,tp,LOCATION_PZONE,0,c,e,tp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if c:IsLocation(LOCATION_MZONE) then ft=ft+1 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	return sg:IsExists(c500315978.rfilter,1,nil,c) or sg:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,ft)
end
function c500315978.mfilter(c)
	return c:GetLevel()>0 and c:IsAbleToGrave()
end
function c500315978.mzfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c500315978.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<0 then return false end
		local mg=Duel.GetRitualMaterial(tp)
		if ft>0 then
			local mg2=Duel.GetMatchingGroup(c500315978.mfilter,tp,LOCATION_EXTRA,0,nil)
			mg:Merge(mg2)
		else
			mg=mg:Filter(c500315978.mzfilter,nil,tp)
		end
		return mg:IsExists(c500315978.filter,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function c500315978.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<0 then return end
	local mg=Duel.GetRitualMaterial(tp)
	if ft>0 then
		local mg2=Duel.GetMatchingGroup(c500315978.mfilter,tp,LOCATION_EXTRA,0,nil)
		mg:Merge(mg2)
	else
		mg=mg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mat=mg:FilterSelect(tp,c500315978.filter,1,1,nil,e,tp)
	local mc=mat:GetFirst()
	if not mc then return end
	local sg=Duel.GetMatchingGroup(c500315978.spfilter,tp,LOCATION_PZONE,0,mc,e,tp,mc)
	if mc:IsLocation(LOCATION_MZONE) then ft=ft+1 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local b1=sg:IsExists(c500315978.rfilter,1,nil,mc)
	local b2=sg:CheckWithSumEqual(Card.GetLevel,mc:GetLevel(),1,ft)
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(500315978,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:FilterSelect(tp,c500315978.rfilter,1,1,nil,mc)
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