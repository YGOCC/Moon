--Digimon Shoutmon X3
function c47000133.initial_effect(c)
c:SetUniqueOnField(1,0,47000133)
--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,47000118,47000120,47000121,false,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c47000133.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c47000133.spcon)
	e2:SetOperation(c47000133.spop)
	c:RegisterEffect(e2)
--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(47000133,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCondition(c47000133.rmcon)
	e3:SetTarget(c47000133.rmtg)
	e3:SetOperation(c47000133.rmop)
	c:RegisterEffect(e3)
--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(47000133,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c47000133.eqtg)
	e4:SetOperation(c47000133.eqop)
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
--indes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e7:SetCountLimit(1)
	e7:SetValue(c47000133.valcon)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetValue(c47000133.valcon1)
	c:RegisterEffect(e8)
end
function c47000133.spfilter(c,code1,code2,code3)
	return c:IsAbleToDeckOrExtraAsCost() and (c:IsFusionCode(code1) or c:IsFusionCode(code2) or c:IsFusionCode(code3))
end
function c47000133.spfilter1(c,mg,ft)
	local mg2=mg:Clone()
	mg2:RemoveCard(c)
	if c:IsLocation(LOCATION_GRAVE) then ft=ft+1 end
	return ft>=-1 and c:IsFusionCode(47000118) and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial()
		and mg2:IsExists(c47000133.spfilter2,1,nil,mg2,ft)
end
function c47000133.spfilter2(c,mg,ft)
	local mg2=mg:Clone()
	mg2:RemoveCard(c)
	if c:IsLocation(LOCATION_GRAVE) then ft=ft+1 end
	return ft>=0 and c:IsFusionCode(47000120) and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial()
		and mg2:IsExists(c47000133.spfilter3,1,nil,ft)
end
function c47000133.spfilter3(c,ft)
	if c:IsLocation(LOCATION_GRAVE) then ft=ft+1 end
	return ft>=1 and c:IsFusionCode(47000121) and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial()
end
function c47000133.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_GRAVE)
	if ft<-2 then return false end
	local mg=Duel.GetMatchingGroup(c47000133.spfilter,tp,LOCATION_GRAVE,0,nil,47000118,47000120,47000121)
	return mg:IsExists(c47000133.spfilter1,1,nil,mg,ft)
end
function c47000133.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_GRAVE)
	local mg=Duel.GetMatchingGroup(c47000133.spfilter,tp,LOCATION_GRAVE,0,nil,47000118,47000120,47000121)
	local g=Group.CreateGroup()
	local tc=nil
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		if i==1 then
			tc=mg:FilterSelect(tp,c47000133.spfilter1,1,1,nil,mg,ft):GetFirst()
		end
		if i==2 then
			tc=mg:FilterSelect(tp,c47000133.spfilter2,1,1,nil,mg,ft):GetFirst()
		end
		if i==3 then
			tc=mg:FilterSelect(tp,c47000133.spfilter3,1,1,nil,ft):GetFirst()
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
function c47000133.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local eg=e:GetHandler():GetEquipGroup()
	return eg and eg:IsExists(Card.IsSetCard,1,nil,0x2EEF) and Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c47000133.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c47000133.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		tc:RegisterFlagEffect(47000133,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetLabelObject(tc)
		e3:SetCountLimit(1)
		e3:SetCondition(c47000133.retcon)
		e3:SetOperation(c47000133.retop)
		Duel.RegisterEffect(e3,tp)
	end
end
function c47000133.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(47000133)~=0
end
function c47000133.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c47000133.filter5(c)
	return c:IsSetCard(0x2EEF) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and not (c:IsForbidden() or c:IsCode(47000124) or c:IsCode(47000118))  
end
function c47000133.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c47000133.filter5,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c47000133.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c47000133.filter5),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c,true) then return end
		local e2=Effect.CreateEffect(c)
		e2:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(c47000133.eqlimit)
		tc:RegisterEffect(e2)
	end
end
function c47000133.eqlimit(e,c)
	return e:GetOwner()==c
end
function c47000133.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c47000133.valcon1(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
