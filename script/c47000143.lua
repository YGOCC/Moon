--Digimon Xros Hi-Vision Monitamon
function c47000143.initial_effect(c)
c:SetUniqueOnField(1,0,47000143)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,47000141,47000141,47000141,false,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c47000143.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c47000143.spcon)
	e2:SetOperation(c47000143.spop)
	c:RegisterEffect(e2)
--confirm
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(47000143,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c47000143.cfop)
	c:RegisterEffect(e3)
--To Hand
  local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c47000143.spcon2)
	e4:SetCost(c47000143.spcost2)
	e4:SetTarget(c47000143.sptg2)
	e4:SetOperation(c47000143.spop2)
	c:RegisterEffect(e4)
	--xyz limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--synchrolimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
end
function c47000143.spfilter(c,code1,code2,code3)
	return c:IsAbleToDeckOrExtraAsCost() and (c:IsFusionCode(code1) or c:IsFusionCode(code2) or c:IsFusionCode(code3))
end
function c47000143.spfilter1(c,mg,ft)
	local mg2=mg:Clone()
	mg2:RemoveCard(c)
	if c:IsLocation(LOCATION_GRAVE) then ft=ft+1 end
	return ft>=-1 and c:IsFusionCode(47000141) and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial()
		and mg2:IsExists(c47000143.spfilter2,1,nil,mg2,ft)
end
function c47000143.spfilter2(c,mg,ft)
	local mg2=mg:Clone()
	mg2:RemoveCard(c)
	if c:IsLocation(LOCATION_GRAVE) then ft=ft+1 end
	return ft>=0 and c:IsFusionCode(47000141) and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial()
		and mg2:IsExists(c47000143.spfilter3,1,nil,ft)
end
function c47000143.spfilter3(c,ft)
	if c:IsLocation(LOCATION_GRAVE) then ft=ft+1 end
	return ft>=1 and c:IsFusionCode(47000141) and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial()
end
function c47000143.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_GRAVE)
	if ft<-2 then return false end
	local mg=Duel.GetMatchingGroup(c47000143.spfilter,tp,LOCATION_GRAVE,0,nil,47000141,47000141,47000141)
	return mg:IsExists(c47000143.spfilter1,1,nil,mg,ft)
end
function c47000143.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_GRAVE)
	local mg=Duel.GetMatchingGroup(c47000143.spfilter,tp,LOCATION_GRAVE,0,nil,47000141,47000141,47000141)
	local g=Group.CreateGroup()
	local tc=nil
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		if i==1 then
			tc=mg:FilterSelect(tp,c47000143.spfilter1,1,1,nil,mg,ft):GetFirst()
		end
		if i==2 then
			tc=mg:FilterSelect(tp,c47000143.spfilter2,1,1,nil,mg,ft):GetFirst()
		end
		if i==3 then
			tc=mg:FilterSelect(tp,c47000143.spfilter3,1,1,nil,ft):GetFirst()
		end
		g:AddCard(tc)
		mg:RemoveCard(tc)
		if tc:IsLocation(LOCATION_GRAVE) then ft=ft+1 end
	end
	local cg=g:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c47000143.cfop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_SZONE,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
	end
end
function c47000143.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c47000143.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c47000143.spfilter5(c,e,tp)
	return c:IsSetCard(0x2EEF) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47000143.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c47000143.spfilter5,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c47000143.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c47000143.spfilter5,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
