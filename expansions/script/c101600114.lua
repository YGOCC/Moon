function c101600114.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xcd01),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--change name
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e0:SetValue(2403771)
	c:RegisterEffect(e0)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101600114,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101600114)
	e1:SetTarget(c101600114.eqtg)
	e1:SetOperation(c101600114.eqop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c101600114.atkval)
	e2:SetCountLimit(1,101600114)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101600114,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c101600114.descost)
	e3:SetTarget(c101600114.destg)
	e3:SetOperation(c101600114.desop)
	e3:SetCountLimit(1,101600114)
	c:RegisterEffect(e3)
	--Destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c101600114.desreptg)
	e4:SetOperation(c101600114.desrepop)
	e4:SetCountLimit(1,101600114)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetTarget(c101600114.desreptg)
	e5:SetOperation(c101600114.desrepop)
	e5:SetCountLimit(1,101600114)
	c:RegisterEffect(e5)
end
function c101600114.CanEquipMonster(c)
	return true
end
function c101600114.eqfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToChangeControler()
end
function c101600114.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(1-tp) and c101600114.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c101600114.eqfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c101600114.eqfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c101600114.eqlimit(e,c)
	return e:GetOwner()==c and e:GetLabelObject():GetFlagEffect(101600114)>0
end
function c101600114.EquipMonster(c,tp,tc)
	if not Duel.Equip(tp,tc,c,false) then return end
	--Add Equip limit
	tc:RegisterFlagEffect(101600114,RESET_EVENT+0x1fe0000,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetLabelObject(tc)
	e1:SetValue(c101600114.eqlimit)
	tc:RegisterEffect(e1)
end
function c101600114.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and tc:IsControler(1-tp) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			c101600114.EquipMonster(c,tp,tc)
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end
function c101600114.atkval(e,c)
	local atk=0
	local g=c:GetEquipGroup()
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(101600114)~=0 and tc:IsFaceup() and tc:GetAttack()>=0 then
			atk=atk+tc:GetLevel()
		end
		tc=g:GetNext()
	end
	return atk*100
end
function c101600114.costfilter(c,tc)
	return c:IsAbleToGraveAsCost() and tc:GetEquipGroup():IsContains(c)
end
function c101600114.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101600114.costfilter,tp,LOCATION_SZONE,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101600114.costfilter,tp,LOCATION_SZONE,0,1,1,nil,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c101600114.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101600114.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c101600114.repfilter(c)
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER and c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c101600114.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=c:GetEquipGroup()
		return not c:IsReason(REASON_REPLACE) and g:IsExists(c101600114.repfilter,1,nil) and c:GetDestination()==LOCATION_REMOVED
	end
	if Duel.SelectYesNo(tp,aux.Stringid(101600114,2)) then
		local g=c:GetEquipGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:FilterSelect(tp,c101600114.repfilter,1,1,nil)
		Duel.SetTargetCard(sg)
		return true
	else return false end
end
function c101600114.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SendtoGrave(tg,REASON_EFFECT+REASON_REPLACE)
end
