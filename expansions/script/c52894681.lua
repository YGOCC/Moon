--Raging Oni Mask
--Scripted by Kedy
--Concept by XStutzX
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
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cod.sptg)
	e1:SetOperation(cod.spop)
	c:RegisterEffect(e1)
	--Salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(cod.thcost)
	e2:SetTarget(cod.thtg)
	e2:SetOperation(cod.thop)
	c:RegisterEffect(e2)
end
function cod.tgfilter(c,e,tp,mg,f,chkf)
	mg:AddCard(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() 	
		and Duel.IsExistingMatchingCard(cod.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,f,c,chkf)
end
function cod.spfilter(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and Duel.GetLocationCountFromEx(tp,tp,m,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)
end
function cod.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
	if chk==0 then return Duel.IsExistingTarget(cod.tgfilter,tp,0,LOCATION_MZONE,1,nil,e,tp,mg1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g=Duel.SelectTarget(tp,cod.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp,mg1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,tp,LOCATION_EXTRA)
	Duel.SetChainLimitTillChainEnd(cod.genchainlm(e:GetHandler()))
end
function cod.genchainlm(c)
	return	function (e,rp,tp)
				return e:GetHandler():GetCode()~=id
			end
end
function cod.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetFlagEffect(tp,id)>0 then return false end
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
	mg1:AddCard(tc)
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanBeFusionMaterial() and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,cod.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg1,nil,nil,tp)
		local sc=sg:GetFirst()
		if sc then
			local mat1=Duel.SelectFusionMaterial(tp,sc,mg1,tc,chkf)
			sc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		end
	end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end

--Salvage
function cod.cfilter(c)
	return c:IsSetCard(0xf05b) 
end
function cod.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and Duel.IsExistingMatchingCard(cod.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,cod.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
end
function cod.thfilter(c)
	return (c:IsSetCard(0xf05a) or c:IsSetCard(0xf05b)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:GetCode()~=id
end
function cod.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cod.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(cod.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetChainLimitTillChainEnd(cod.genchainlm(e:GetHandler()))
end
function cod.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetFlagEffect(tp,id)>1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cod.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g<=0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,0)
end