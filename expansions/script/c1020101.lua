--Galactic Code Upgrade
--Automate ID
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()

function scard.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(function(e,tp,blah,blah,card,games,waaa,dodalalalalala,chk) if chk==0 then return Duel.CheckLPCost(tp,1000) end Duel.PayLPCost(tp,1000) end)
	e1:SetTarget(scard.target)
	e1:SetOperation(scard.activate)
	e1:SetCountLimit(1,s_id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
function scard.filter0(c)
	return c:IsOnField() and c:IsAbleToRemove()
end
function scard.filter1(c,e)
	return c:IsOnField() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function scard.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x1ded) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function scard.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function scard.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(scard.filter0,nil)
		local mg2=Duel.GetMatchingGroup(scard.filter3,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(scard.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(scard.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function scard.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(scard.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(scard.filter3,tp,LOCATION_GRAVE,0,nil)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(scard.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(scard.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			if Duel.SpecialSummonStep(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_ATTACK)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1,true)
				Duel.SpecialSummonComplete()
			end
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
