--Seeking Oni Mask
--Scripted by Kedy
--Concept by XStutzX
--Edited 16.9.18 v1.1
local function ID()
    local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
    str=string.sub(str,1,string.len(str)-4)
    local cod=_G[str]
    local id=tonumber(string.sub(str,2))
    return id,cod
end

local id,cod=ID()
function cod.initial_effect(c)
	--Fusion Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cod.sptg)
	e1:SetOperation(cod.spop)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(cod.thcost)
	e2:SetTarget(cod.thtg)
	e2:SetOperation(cod.thop)
	c:RegisterEffect(e2)
	cod[c]=e1
end

--Fusion Summon
function cod.filter1(c)
	return (c:IsSetCard(0xf05b) or (not c:IsType(TYPE_EFFECT) and c:IsType(TYPE_FUSION))) and c:IsCanBeFusionMaterial()
end
function cod.filter2(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xf05b) and (not f or f(c)) and Duel.GetLocationCountFromEx(tp,tp,m,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)
end
function cod.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND)
		local mg3=Duel.GetMatchingGroup(cod.filter1,tp,LOCATION_EXTRA,0,nil)
		mg1:Merge(mg3)
		mg1:AddCard(c)
		local res=Duel.IsExistingMatchingCard(cod.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cod.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,nil,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetChainLimitTillChainEnd(cod.genchainlm(c))
end
function cod.genchainlm(c)
	return	function (e,rp,tp)
				return e:GetHandler():GetCode()~=id
			end
end
function cod.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	if Duel.GetFlagEffect(tp,id)>0 then return false end
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND)
	local mg3=Duel.GetMatchingGroup(cod.filter1,tp,LOCATION_EXTRA,0,nil)
	mg1:Merge(mg3)
	mg1:AddCard(c)
	local sg1=Duel.GetMatchingGroup(cod.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cod.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,nil,chkf)
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
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end

--Search
function cod.cfilter(c)
	return c:IsSetCard(0xf05b) 
end
function cod.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and Duel.IsExistingMatchingCard(cod.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,cod.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
end
function cod.thfilter(c)
	return c:IsSetCard(0xf05a) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cod.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsAbleToHand() and cod.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(cod.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetChainLimitTillChainEnd(cod.genchainlm(e:GetHandler()))
end
function cod.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetFlagEffect(tp,id)>0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cod.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g<=0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
