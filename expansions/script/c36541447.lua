--Wirush, Wielder of Engraved Armaments
--Script by XGlitchy30
function c36541447.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(36541447,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,36541447)
	e1:SetTarget(c36541447.eqtg)
	e1:SetOperation(c36541447.eqop)
	c:RegisterEffect(e1)
	--recover resources
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(36541447,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,36540447)
	e2:SetLabel(0)
	e2:SetCondition(c36541447.rrcon)
	e2:SetCost(c36541447.rrcost)
	e2:SetTarget(c36541447.rrtg)
	e2:SetOperation(c36541447.rrop)
	c:RegisterEffect(e2)
end
--filters
function c36541447.fixequip(c,ec)
	return c:IsSetCard(0x824a) and c:GetEquipTarget()==nil or (c:IsSetCard(0x824a) and c:GetEquipTarget()~=nil and c:GetEquipTarget()~=ec)
end
function c36541447.cfilter(c,tp)
	return c:IsReason(REASON_DESTROY) and c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp)
end
--equip
function c36541447.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c36541447.fixequip,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler(),e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function c36541447.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c36541447.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eqp=Duel.SelectMatchingCard(tp,c36541447.fixequip,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,c,c)
	local eq=eqp:GetFirst()
	if eq then
		if c:IsFaceup() then
			if Duel.Equip(tp,eq,c,true) then
				--Add Equip limit
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(c36541447.eqlimit)
				e1:SetLabelObject(c)
				eq:RegisterEffect(e1)
			else Duel.SendtoGrave(eq,REASON_EFFECT) end
		end
	end
end
--recover resources
function c36541447.rrcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c36541447.cfilter,1,nil,tp)
end
function c36541447.rrcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_SZONE,0,1,nil) end
	local group=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_SZONE,0,nil)
	local check=eg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	local ft=nil
	if group:GetCount()>check:GetCount() then ft=check:GetCount()
	elseif group:GetCount()<=check:GetCount() then ft=group:GetCount()
	else return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sptp=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_SZONE,0,1,ft,nil)
	local ct=Duel.SendtoGrave(sptp,nil,REASON_COST)
	e:SetLabel(ct)
end
function c36541447.rrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,ct,tp,LOCATION_GRAVE)
end
function c36541447.rrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local rcv=eg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_GRAVE)
	local eq=rcv:GetFirst()
	while eq do
		if c:IsFaceup() then
			if Duel.Equip(tp,eq,c,true) then
				--Add Equip limit
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(c36541447.eqlimit)
				e1:SetLabelObject(c)
				eq:RegisterEffect(e1)
			else Duel.SendtoGrave(eq,REASON_EFFECT) end
		end
	eq=rcv:GetNext()
	end
end