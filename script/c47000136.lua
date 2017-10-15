--Digimon DeckerGreymon
function c47000136.initial_effect(c)
c:SetUniqueOnField(1,0,47000136)
--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,47000124,47000125,47000135,false,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c47000136.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c47000136.spcon)
	e2:SetOperation(c47000136.spop)
	c:RegisterEffect(e2)
--Destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(47000136,0))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(c47000136.desreptg)
	e3:SetOperation(c47000136.desrepop)
	c:RegisterEffect(e3)
--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(47000136,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c47000136.eqtg)
	e4:SetOperation(c47000136.eqop)
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
--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(47000136,2))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(c47000136.cost)
	e7:SetTarget(c47000136.target)
	e7:SetOperation(c47000136.activate)
	c:RegisterEffect(e7)
end
function c47000136.spfilter(c,code1,code2,code3)
	return c:IsAbleToDeckOrExtraAsCost() and (c:IsFusionCode(code1) or c:IsFusionCode(code2) or c:IsFusionCode(code3))
end
function c47000136.spfilter1(c,mg,ft)
	local mg2=mg:Clone()
	mg2:RemoveCard(c)
	if c:IsLocation(LOCATION_REMOVED) then ft=ft+1 end
	return ft>=-1 and c:IsFusionCode(47000124) and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial()
		and mg2:IsExists(c47000136.spfilter2,1,nil,mg2,ft)
end
function c47000136.spfilter2(c,mg,ft)
	local mg2=mg:Clone()
	mg2:RemoveCard(c)
	if c:IsLocation(LOCATION_REMOVED) then ft=ft+1 end
	return ft>=0 and c:IsFusionCode(47000125) and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial()
		and mg2:IsExists(c47000136.spfilter3,1,nil,ft)
end
function c47000136.spfilter3(c,ft)
	if c:IsLocation(LOCATION_REMOVED) then ft=ft+1 end
	return ft>=1 and c:IsFusionCode(47000135) and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial()
end
function c47000136.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_REMOVED)
	if ft<-2 then return false end
	local mg=Duel.GetMatchingGroup(c47000136.spfilter,tp,LOCATION_REMOVED,0,nil,47000124,47000125,47000135)
	return mg:IsExists(c47000136.spfilter1,1,nil,mg,ft)
end
function c47000136.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_REMOVED)
	local mg=Duel.GetMatchingGroup(c47000136.spfilter,tp,LOCATION_REMOVED,0,nil,47000124,47000125,47000135)
	local g=Group.CreateGroup()
	local tc=nil
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		if i==1 then
			tc=mg:FilterSelect(tp,c47000136.spfilter1,1,1,nil,mg,ft):GetFirst()
		end
		if i==2 then
			tc=mg:FilterSelect(tp,c47000136.spfilter2,1,1,nil,mg,ft):GetFirst()
		end
		if i==3 then
			tc=mg:FilterSelect(tp,c47000136.spfilter3,1,1,nil,ft):GetFirst()
		end
		g:AddCard(tc)
		mg:RemoveCard(tc)
		if tc:IsLocation(LOCATION_REMOVED) then ft=ft+1 end
	end
	local cg=g:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end



function c47000136.repfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2EEF) and c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c47000136.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=c:GetEquipGroup()
		return not c:IsReason(REASON_REPLACE) and g:IsExists(c47000136.repfilter,1,nil)
	end
	if Duel.SelectYesNo(tp,aux.Stringid(2403771,1)) then
		local g=c:GetEquipGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:FilterSelect(tp,c47000136.repfilter,1,1,nil)
		Duel.SetTargetCard(sg)
		return true
	else return false end
end
function c47000136.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SendtoGrave(tg,REASON_EFFECT+REASON_REPLACE)
end
function c47000136.filter5(c)
	return c:IsSetCard(0x2EEF) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and not (c:IsForbidden() or c:IsCode(47000124) or c:IsCode(47000118))  
end
function c47000136.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c47000136.filter5,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c47000136.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c47000136.filter5),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c,true) then return end
		local e2=Effect.CreateEffect(c)
		e2:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(c47000136.eqlimit)
		tc:RegisterEffect(e2)
	end
end
function c47000136.eqlimit(e,c)
	return e:GetOwner()==c
end
function c47000136.costfilter(c)
	return c:IsSetCard(0x2EEF) and c:IsType(TYPE_MONSTER)  and not c:IsCode(47000136) and c:IsAbleToRemoveAsCost()
end
function c47000136.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47000136.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c47000136.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c47000136.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c47000136.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
