local m=110600012
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--place in pen zone
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.pentg)
	e2:SetOperation(cm.penop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c)
	return c:IsSetCard(0x303)
end
function cm.cmfilter(c)
	return cm.cfilter(c) and c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function cm.mfilter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function cm.mfilter1(c,e)
	return not c:IsImmuneToEffect(e) and (c:IsLocation(LOCATION_FIELD) or c:IsLocation(LOCATION_HAND))
end
function cm.mfilter2(c,e)
	return c:IsType(TYPE_MONSTER) and cm.cmfilter(c)
	and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function cm.spfilter1(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) 
		and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(cm.mfilter2,tp,LOCATION_EXTRA,0,nil,e)
		mg2:Merge(mg1)
		return Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,nil,chkf) 
		and Duel.GetLocationCountFromEx(tp)~=0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.mfilter1,nil,e)
	local mg2=Duel.GetMatchingGroup(cm.mfilter2,tp,LOCATION_EXTRA,0,nil,e)
	mg2:Merge(mg1)
	local sg1=Duel.GetMatchingGroup(cm.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,nil,chkf)
	if sg1:GetCount()>0 then
		local sg=sg1:Clone()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mat1=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
		tc:SetMaterial(mat1)
		local mat2=mat1:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		mat1:Sub(mat2)
		Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		if Duel.SendtoDeck(mat2,nil,1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)>0 then
			Duel.ShuffleDeck(tp)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function cm.penfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and cm.cfilter(c)
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.penfilter(chkc) end
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingTarget(cm.penfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local g=Duel.SelectTarget(tp,cm.penfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end