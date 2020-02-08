--created by Walrus, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	aux.CannotBeEDMaterial(c,nil,LOCATION_MZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1056)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.ftg)
	e1:SetOperation(cid.fop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(1164)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetTarget(cid.stg)
	e2:SetOperation(cid.sop)
	c:RegisterEffect(e2)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() and c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
end
function cid.filter0(c)
	return c:IsLocation(LOCATION_HAND) and c:IsAbleToRemove()
end
function cid.filter1(c,e)
	return c:IsLocation(LOCATION_HAND) and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function cid.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xc97) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,e:GetHandler(),chkf)
end
function cid.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function cid.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(cid.filter0,nil)
		local mg2=Duel.GetMatchingGroup(cid.filter3,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(cid.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cid.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cid.fop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(cid.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(cid.filter3,tp,LOCATION_GRAVE,0,nil)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(cid.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cid.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,e:GetHandler(),chkf)
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2,SUMMON_TYPE_FUSION)
		end
		tc:CompleteProcedure()
	end
end
function cid.sfilter0(rg,c,lv)
	return rg:CheckWithSumEqual(Card.GetLevel,lv,#rg,#rg) and rg:IsExists(function(tc) return tc:IsAttribute(ATTRIBUTE_DARK) and tc:IsNotTuner(c) end,1,nil)
end
function cid.sfilter1(c,e,tp)
	local lv=c:GetLevel()-e:GetHandler():GetLevel()
	local rg=Duel.GetMatchingGroup(cid.sfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	aux.GCheckAdditional=function(g) return g:GetSum(Card.GetLevel)<=lv end
	local res=c:IsType(TYPE_SYNCHRO) and lv>0 and c:IsSetCard(0xc97) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and rg:CheckSubGroup(cid.sfilter0,1,lv,c,lv)
	aux.GCheckAdditional=nil
	return res
end
function cid.sfilter2(c)
	return c:GetLevel()>0 and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
end
function cid.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 and e:GetHandler():IsAbleToRemove()
		and Duel.IsExistingMatchingCard(cid.sfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cid.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsAbleToRemove() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,cid.sfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g1==0 then return end
	local lv=g1:GetFirst():GetLevel()-c:GetLevel()
	local rg=Duel.GetMatchingGroup(cid.sfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=rg:SelectWithSumEqual(tp,Card.GetLevel,lv,1,63)+c
	g1:GetFirst():SetMaterial(g2)
	Duel.Remove(g2,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)
	Duel.BreakEffect()
	Duel.SpecialSummon(g1,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	g1:GetFirst():CompleteProcedure()
end
