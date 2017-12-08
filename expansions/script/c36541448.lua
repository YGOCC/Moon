--Kaim, Enhancer of Engraved Armaments
--Script by XGlitchy30
function c36541448.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(36541448,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,36541448)
	e1:SetTarget(c36541448.eqtg)
	e1:SetOperation(c36541448.eqop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(36541448,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,36540448)
	e2:SetCost(c36541448.drcost)
	e2:SetTarget(c36541448.drtg)
	e2:SetOperation(c36541448.drop)
	c:RegisterEffect(e2)
end
--filters
function c36541448.fixequip(c,ec)
	return c:IsSetCard(0x824a) and c:GetEquipTarget()==nil or (c:IsSetCard(0x824a) and c:GetEquipTarget()~=nil and c:GetEquipTarget()~=ec)
end
--equip
function c36541448.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c36541448.fixequip,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler(),e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function c36541448.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c36541448.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eqp=Duel.SelectMatchingCard(tp,c36541448.fixequip,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,c,c)
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
				e1:SetValue(c36541448.eqlimit)
				e1:SetLabelObject(c)
				eq:RegisterEffect(e1)
			else Duel.SendtoGrave(eq,REASON_EFFECT) end
		end
	end
end
--draw
function c36541448.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.Draw(tp,1,REASON_EFFECT)
	local effect=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local eff=effect:GetFirst()
	while eff do
		eff:RegisterFlagEffect(36541448,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,1)
		eff=effect:GetNext()
	end
end
function c36541448.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c36541448.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
end
function c36541448.allow_trg(c)
	return c:IsSetCard(0x824a)
end