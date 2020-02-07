--Nuei, Keeper of Engraved Armaments
--Script by XGlitchy30
function c36541444.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(36541444,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,36541444)
	e1:SetTarget(c36541444.eqtg)
	e1:SetOperation(c36541444.eqop)
	c:RegisterEffect(e1)
	--recover resources
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,36540444)
	e2:SetCondition(c36541444.rrcon)
	e2:SetTarget(c36541444.rrtg)
	e2:SetOperation(c36541444.rrop)
	c:RegisterEffect(e2)
end
--filters
function c36541444.fixequip(c,ec)
	return c:IsSetCard(0x824a) and c:GetEquipTarget()==nil or (c:IsSetCard(0x824a) and c:GetEquipTarget()~=nil and c:GetEquipTarget()~=ec)
end
function c36541444.cfilter(c,tp)
	return not c:IsReason(REASON_DESTROY) and c:IsSetCard(0x8ea2) and c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp)
end
function c36541444.addfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x8ea2)
end
--equip
function c36541444.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c36541444.fixequip,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler(),e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function c36541444.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c36541444.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eqp=Duel.SelectMatchingCard(tp,c36541444.fixequip,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,c,c)
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
				e1:SetValue(c36541444.eqlimit)
				e1:SetLabelObject(c)
				eq:RegisterEffect(e1)
			else Duel.SendtoGrave(eq,REASON_EFFECT) end
		end
	end
end
--recover resources
function c36541444.rrcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetEquipGroup()
	return eg:IsExists(c36541444.cfilter,1,nil,tp) and eq:GetCount()>0
end
function c36541444.rrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=eg:Filter(c36541444.addfilter,nil)
		return ct:GetCount()>0
	end
	Duel.SetTargetCard(eg)
	local c=e:GetHandler()
	local eq=c:GetEquipGroup()
	local g=eg:Filter(c36541444.addfilter,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,eq:GetCount(),0,0)
end
function c36541444.rrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetEquipGroup()
	local rcv=eg:FilterSelect(tp,c36541444.addfilter,1,eq:GetCount(),nil)
	if rcv:GetCount()>0 then
		Duel.SendtoHand(rcv,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,rcv)
	end
end