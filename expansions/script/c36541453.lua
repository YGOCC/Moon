--Ancient Engraved Array - Antikythera
--Script by XGlitchy30
function c36541453.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x8ea2),2)
	c:EnableReviveLimit()
	--immunity
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c36541453.attcon1)
	e0:SetValue(c36541453.efilter1)
	c:RegisterEffect(e0)
	local e11=e0:Clone()
	e11:SetCondition(c36541453.attcon2)
	e11:SetValue(c36541453.efilter2)
	c:RegisterEffect(e11)
	local e12=e0:Clone()
	e12:SetCondition(c36541453.attcon3)
	e12:SetValue(c36541453.efilter3)
	c:RegisterEffect(e12)
	local e13=e0:Clone()
	e13:SetCondition(c36541453.attcon4)
	e13:SetValue(c36541453.efilter4)
	c:RegisterEffect(e13)
	local e14=e0:Clone()
	e14:SetCondition(c36541453.attcon5)
	e14:SetValue(c36541453.efilter5)
	c:RegisterEffect(e14)
	local e15=e0:Clone()
	e15:SetCondition(c36541453.attcon6)
	e15:SetValue(c36541453.efilter6)
	c:RegisterEffect(e15)
	local e16=e0:Clone()
	e16:SetCondition(c36541453.attcon7)
	e16:SetValue(c36541453.efilter7)
	c:RegisterEffect(e16)
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_SINGLE)
	e17:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e17:SetCode(EFFECT_IMMUNE_EFFECT)
	e17:SetRange(LOCATION_MZONE)
	e17:SetValue(c36541453.sptp_immunity)
	c:RegisterEffect(e17)
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetCondition(c36541453.attgain1)
	e2:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(c36541453.attgain2)
	e3:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCondition(c36541453.attgain3)
	e4:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCondition(c36541453.attgain4)
	e5:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e5)
	local e6=e2:Clone()
	e6:SetCondition(c36541453.attgain5)
	e6:SetValue(ATTRIBUTE_EARTH)
	c:RegisterEffect(e6)
	local e7=e2:Clone()
	e7:SetCondition(c36541453.attgain6)
	e7:SetValue(ATTRIBUTE_WIND)
	c:RegisterEffect(e7)
	local e8=e2:Clone()
	e8:SetCondition(c36541453.attgain7)
	e8:SetValue(ATTRIBUTE_DIVINE)
	c:RegisterEffect(e8)
	--atkgain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c36541453.atkval)
	c:RegisterEffect(e1)
	--redirect
	local rdt=Effect.CreateEffect(c)
	rdt:SetType(EFFECT_TYPE_FIELD)
	rdt:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	rdt:SetRange(LOCATION_MZONE)
	rdt:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	rdt:SetTargetRange(0xff,0xff)
	rdt:SetValue(LOCATION_GRAVE)
	c:RegisterEffect(rdt)
	--cannot banish
	local ban=Effect.CreateEffect(c)
	ban:SetType(EFFECT_TYPE_FIELD)
	ban:SetRange(LOCATION_MZONE)
	ban:SetCode(EFFECT_CANNOT_REMOVE)
	ban:SetTargetRange(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0)
	c:RegisterEffect(ban)
	--equip
	local eq=Effect.CreateEffect(c)
	eq:SetCategory(CATEGORY_EQUIP)
	eq:SetType(EFFECT_TYPE_QUICK_O)
	eq:SetCode(EVENT_FREE_CHAIN)
	eq:SetRange(LOCATION_MZONE)
	eq:SetCountLimit(1)
	eq:SetTarget(c36541453.eqtg)
	eq:SetOperation(c36541453.equip)
	c:RegisterEffect(eq)
end
--atk value
function c36541453.atkval(e,c)
	local link=c:GetLinkedGroup()
	return link:GetClassCount(Card.GetAttribute)*600
end
--attribute gain	
function c36541453.attgain1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetLinkedGroup()
	return eq:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT)
end
function c36541453.attgain2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetLinkedGroup()
	return eq:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK)
end
function c36541453.attgain3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetLinkedGroup()
	return eq:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WATER)
end
function c36541453.attgain4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetLinkedGroup()
	return eq:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_FIRE)
end
function c36541453.attgain5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetLinkedGroup()
	return eq:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_EARTH)
end
function c36541453.attgain6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetLinkedGroup()
	return eq:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WIND)
end
function c36541453.attgain7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetLinkedGroup()
	return eq:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DIVINE)
end
--attribute condition
function c36541453.attcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttribute(ATTRIBUTE_LIGHT)
end
function c36541453.attcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttribute(ATTRIBUTE_DARK)
end
function c36541453.attcon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttribute(ATTRIBUTE_WATER)
end
function c36541453.attcon4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttribute(ATTRIBUTE_FIRE)
end
function c36541453.attcon5(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttribute(ATTRIBUTE_EARTH)
end
function c36541453.attcon6(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttribute(ATTRIBUTE_WIND)
end
function c36541453.attcon7(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttribute(ATTRIBUTE_DIVINE)
end
--immunity value	
function c36541453.sptp_immunity(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end	
function c36541453.efilter1(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetHandler():GetAttribute()==ATTRIBUTE_LIGHT
end
function c36541453.efilter2(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetHandler():GetAttribute()==ATTRIBUTE_DARK
end	
function c36541453.efilter3(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetHandler():GetAttribute()==ATTRIBUTE_WATER
end	
function c36541453.efilter4(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetHandler():GetAttribute()==ATTRIBUTE_FIRE
end	
function c36541453.efilter5(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetHandler():GetAttribute()==ATTRIBUTE_EARTH
end	
function c36541453.efilter6(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetHandler():GetAttribute()==ATTRIBUTE_WIND
end	
function c36541453.efilter7(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetHandler():GetAttribute()==ATTRIBUTE_DIVINE
end
--equip
function c36541453.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c36541453.eqtarget,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND)
end
function c36541453.equip(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c36541453.eqtarget,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local eq=Duel.SelectMatchingCard(tp,c36541453.eqfilter,tp,LOCATION_HAND,0,1,1,nil)
		if eq:GetCount()>0 then
			if not Duel.Equip(tp,eq:GetFirst(),tc,true) then return end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetLabelObject(tc)
			e1:SetValue(c36541453.eqlimit)
			eq:GetFirst():RegisterEffect(e1)
		end
	end
end
function c36541453.eqtarget(c)
	return c:IsFaceup() and c:IsSetCard(0x824a)
		and Duel.IsExistingMatchingCard(c36541453.eqfilter,tp,LOCATION_HAND,0,1,nil)
end
function c36541453.eqfilter(c)
	return c:IsSetCard(0x824a)
end
function c36541453.eqlimit(e,c)
	return e:GetLabelObject()==c
end