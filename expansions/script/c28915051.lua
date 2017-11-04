--Ma'at, Guardian of Balance
--Design and Code by Kindrindra
local ref=_G['c'..28915051]
function ref.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,ref.matfilter1,ref.matfilter2,true,true)
	--SpSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_FUSION)
	e1:SetCondition(ref.spcon)
	e1:SetOperation(ref.spop)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28915051,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(ref.discon)
	e2:SetTarget(ref.distg)
	e2:SetOperation(ref.disop)
	c:RegisterEffect(e2)
	--Phantom Fusion
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(ref.fustg)
	e3:SetOperation(ref.fusop)
	c:RegisterEffect(e3)
end
function ref.matfilter1(c)
	return c:IsRace(RACE_DRAGON)
end
function ref.matfilter2(c)
	return c:IsRace(RACE_FAIRY)
end

function ref.spcfilter1(c,tp,fc)
	return ref.matfilter1(c) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(ref.spcfilter2,tp,LOCATION_MZONE,0,1,c,fc,c)
end
function ref.spcfilter2(c,fc,mat1)
	return ((mat1:IsLevelAbove(8) and mat1:IsAttribute(ATTRIBUTE_LIGHT)) or (c:IsLevelAbove(8) and c:IsAttribute(ATTRIBUTE_LIGHT)))
		and ref.matfilter2(c) and c:IsCanBeFusionMaterial(fc) and c:IsAbleToGraveAsCost()
end
function ref.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(ref.spcfilter1,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,ref.spcfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	local g2=Duel.SelectMatchingCard(tp,ref.spcfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),c,g1:GetFirst())
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end

function ref.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) --and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function ref.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
		and Duel.IsExistingTarget(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_SPELL)
		and Duel.IsExistingTarget(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_TRAP)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_GRAVE,0,1,1,nil,TYPE_MONSTER)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_GRAVE,0,1,1,nil,TYPE_SPELL)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g3=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_GRAVE,0,1,1,nil,TYPE_TRAP)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,g1:GetCount(),tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function ref.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.SendtoDeck(g,nil,0,REASON_EFFECT) then
		local ct=g:Filter(Card.IsLocation,nil,LOCATION_DECK):GetCount()
		Duel.SortDecktop(tp,tp,ct)
		Duel.NegateActivation(ev)
	end
end

function ref.spfilter1(c,e)
	return c:IsCode(18631392) and c:IsCanBeFusionMaterial()
		and not c:IsImmuneToEffect(e)
end
function ref.spfilter2(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function ref.spfilter3(c,e,tp,m,g,f,chkf)
	return c==e:GetHandler() and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and g:IsExists(ref.spfilter4,1,nil,m,c,chkf)
end
function ref.spfilter4(c,m,fusc,chkf)
	return fusc:CheckFusionMaterial(m,c,chkf)
end
function ref.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(ref.spfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
		if g:GetCount()==0 then return false end
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		local res=Duel.IsExistingMatchingCard(ref.spfilter3,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg1,g,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(ref.spfilter3,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg2,g,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function ref.fusop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(ref.spfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
	g:Remove(Card.IsImmuneToEffect,nil,e)
	if g:GetCount()==0 then return false end
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(ref.spfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(ref.spfilter3,tp,LOCATION_GRAVE,0,nil,e,tp,mg1,g,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(ref.spfilter3,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,g,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		local tc=e:GetHandler()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local ec=g:FilterSelect(tp,ref.spfilter4,1,1,nil,mg1,tc,chkf):GetFirst()
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,ec,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local ec=g:FilterSelect(tp,ref.spfilter4,1,1,nil,mg2,tc,chkf):GetFirst()
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,ec,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end