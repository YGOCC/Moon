--Digimon Xros Greymon
function c47000124.initial_effect(c)
c:SetUniqueOnField(1,0,47000124)
--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47000124,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(1)
	e1:SetCondition(c47000124.spcon)
	e1:SetOperation(c47000124.spop)
	c:RegisterEffect(e1)
--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47000124,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c47000124.eqtg)
	e2:SetOperation(c47000124.eqop)
	c:RegisterEffect(e2)
--xyz limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--synchrolimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c47000124.synlimit)
	c:RegisterEffect(e4)
--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(47000124,2))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c47000124.cost)
	e5:SetTarget(c47000124.target)
	e5:SetOperation(c47000124.activate)
	c:RegisterEffect(e5)
end
function c47000124.spfilter(c)
	return c:IsSetCard(0x2EEF) and c:IsType(TYPE_MONSTER) and not c:IsCode(47000124) and c:IsAbleToRemoveAsCost()
end
function c47000124.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c47000124.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil)
end
function c47000124.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c47000124.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c47000124.filter(c)
	return c:IsSetCard(0x2EEF) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and not (c:IsForbidden() or c:IsCode(47000124) or c:IsCode(47000118))  
end
function c47000124.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c47000124.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c47000124.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c47000124.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c,true) then return end
		local e2=Effect.CreateEffect(c)
		e2:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(c47000124.eqlimit)
		tc:RegisterEffect(e2)
	end
end
function c47000124.eqlimit(e,c)
	return e:GetOwner()==c
end
function c47000124.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x2EEF) 
end
function c47000124.costfilter(c)
	return c:IsSetCard(0x2EEF) and not c:IsCode(47000124) and c:IsAbleToRemoveAsCost()
end
function c47000124.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47000124.costfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c47000124.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c47000124.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c47000124.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
