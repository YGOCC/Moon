--Ｚ・フュージョン
--Zero Fusion
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
	--Fusion
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(scard.sptg)
	e1:SetOperation(scard.spop)
	c:RegisterEffect(e1)
	if not scard.global_check then
		scard.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(scard.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function scard.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,30000)==0 then 
		Duel.CreateToken(tp,30000)
		Duel.CreateToken(1-tp,30000)
		Duel.RegisterFlagEffect(0,30000,0,0,0)
	end
end
function scard.mfilter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function scard.mfilter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function scard.mfilter2(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function scard.spfilter1(c,e,tp,m,f)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,tp)
end
function scard.spfilter2(c,e,tp,m,f)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x8) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,tp)
end
function scard.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(scard.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil)
		if res then return true end
		local mg2=Group.CreateGroup()
		if not Duel.IsPlayerAffectedByEffect(tp,69832741) then
			mg2:Merge(Duel.GetMatchingGroup(scard.mfilter0,tp,LOCATION_GRAVE,0,nil))
		end
		mg2:Merge(mg1)
		res=Duel.IsExistingMatchingCard(scard.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,nil)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(scard.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function scard.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local mg1=Duel.GetFusionMaterial(tp):Filter(scard.mfilter1,nil,e)
	local sg1=Duel.GetMatchingGroup(scard.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil)
	local mg2=Group.CreateGroup()
	if not Duel.IsPlayerAffectedByEffect(tp,69832741) then
		mg2:Merge(Duel.GetMatchingGroup(scard.mfilter2,tp,LOCATION_GRAVE,0,nil,e))
	end
	mg2:Merge(mg1)
	local sg2=Duel.GetMatchingGroup(scard.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,nil)
	sg1:Merge(sg2)
	local mg3=nil
	local sg3=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg3=Duel.GetMatchingGroup(scard.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf)
	end
	if sg1:GetCount()>0 or (sg3~=nil and sg3:GetCount()>0) then
		local sg=sg1:Clone()
		if sg3 then sg:Merge(sg3) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg3==nil or not sg3:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if tc:IsSetCard(0x8) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg2,nil,tp)
				tc:SetMaterial(mat1)
				local mat2=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
				mat1:Sub(mat2)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				if Duel.Remove(mat2,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)>0 then
					Duel.RegisterFlagEffect(tp,s_id,0,0,1)
				end
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg1,nil,tp)
				tc:SetMaterial(mat2)
				Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			end
			Duel.BreakEffect()
			if Duel.SpecialSummonStep(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) and Duel.GetFlagEffect(tp,s_id)>0 then
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_SET_BASE_ATTACK)
				e3:SetValue(0)
				e3:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e3)
				local e4=e3:Clone()
				e4:SetCode(EFFECT_SET_BASE_DEFENSE)
				tc:RegisterEffect(e4)
				Duel.ResetFlagEffect(tp,s_id)
				Duel.SpecialSummonComplete()
			end
		else
			local mat=Duel.SelectFusionMaterial(tp,tc,mg3,nil,tp)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat)
		end
		tc:CompleteProcedure()
	end
end
