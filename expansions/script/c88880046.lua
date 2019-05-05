--Universal Fusion
function c88880046.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c88880046.cost)
	e1:SetTarget(c88880046.target)
	e1:SetOperation(c88880046.activate)
	c:RegisterEffect(e1)
end
function c88880046.costfilter(c)
	return c:IsAbleToGraveAsCost()
		and (c:IsSetCard(0x889) or c:IsLocation(LOCATION_HAND))
end
function c88880046.regfilter(c,attr)
	return c:IsSetCard(0x889) and bit.band(c:GetOriginalType(),attr)~=0
end
function c88880046.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fg=Group.CreateGroup()
	local loc=LOCATION_HAND
	if fg:GetCount()>0 then loc=LOCATION_HAND+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c88880046.costfilter,tp,loc,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c88880046.costfilter,tp,loc,0,1,1,e:GetHandler())
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		local fc=nil
		if fg:GetCount()==1 then
			fc=fg:GetFirst()
		else
			fc=fg:Select(tp,1,1,nil)
		end
		Duel.Hint(HINT_CARD,0,fc:GetCode())
	end
	local flag=0
	if g:IsExists(c88880046.regfilter,1,nil,TYPE_PENDULUM) then flag=bit.bor(flag,0x1) end
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(flag)
end
function c88880046.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c88880046.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c88880046.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c88880046.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local flag=e:GetLabel(flag)
	if bit.band(flag,0x1)~=0 then
		if chk==0 then
			local chkf=tp
			local mg1=Duel.GetFusionMaterial(tp)
			local mg2=Duel.GetMatchingGroup(c88880046.filter0,tp,LOCATION_DECK,0,nil)
			mg1:Merge(mg2)
			local res=Duel.IsExistingMatchingCard(c88880046.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
			if not res then
				local ce=Duel.GetChainMaterial(tp)
				if ce~=nil then
					local fgroup=ce:GetTarget()
					local mg2=fgroup(ce,e,tp)
					local mf=ce:GetValue()
					res=Duel.IsExistingMatchingCard(c88880046.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
				end
			end
			return res
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	else
		if chk==0 then
			local chkf=tp
			local mg1=Duel.GetFusionMaterial(tp)
			local res=Duel.IsExistingMatchingCard(c88880046.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
			if not res then
				local ce=Duel.GetChainMaterial(tp)
				if ce~=nil then
					local fgroup=ce:GetTarget()
					local mg2=fgroup(ce,e,tp)
					local mf=ce:GetValue()
					res=Duel.IsExistingMatchingCard(c88880046.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
				end
			end
			return res
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function c88880046.activate(e,tp,eg,ep,ev,re,r,rp)
	local flag=e:GetLabel(flag)
	local chkf=tp
	if bit.band(flag,0x1)~=0 then
		local mg1=Duel.GetFusionMaterial(tp):Filter(c88880046.filter1,nil,e)
		local mg2=Duel.GetMatchingGroup(c88880046.filter0,tp,LOCATION_DECK,0,nil)
		mg1:Merge(mg2)
		local sg1=Duel.GetMatchingGroup(c88880046.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		local mg3=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(c88880046.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
		end
		if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
			local sg=sg1:Clone()
			if sg2 then sg:Merge(sg2) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat1)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
				local fop=ce:GetOperation()
				fop(ce,e,tp,tc,mat2)
			end
			tc:CompleteProcedure()
		end
	else
		local mg1=Duel.GetFusionMaterial(tp):Filter(c88880046.filter1,nil,e)
		local sg1=Duel.GetMatchingGroup(c88880046.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		local mg2=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(c88880046.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
		end
		if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
			local sg=sg1:Clone()
			if sg2 then sg:Merge(sg2) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat1)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
				local fop=ce:GetOperation()
				fop(ce,e,tp,tc,mat2)
			end
			tc:CompleteProcedure()
		end
	end
end
