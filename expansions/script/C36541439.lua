--Engraved Armament - Kogeki
--Script by XGlitchy30
function c36541439.initial_effect(c)
	--runic trigger
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(36541439,0))
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetCondition(c36541439.runicon)
	e1:SetCost(c36541439.runicost)
	e1:SetTarget(c36541439.runictg)
	e1:SetOperation(c36541439.runicop)
	c:RegisterEffect(e1)
	--kaim special condition
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(36541439,0))
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetCondition(c36541439.krunicon)
	e2:SetCost(c36541439.krunicost)
	e2:SetTarget(c36541439.krunictg)
	e2:SetOperation(c36541439.krunicop)
	c:RegisterEffect(e2)
end
--filters
function c36541439.allow_tg(c)
	return c:GetFlagEffect(36541448)~=0
end
--values
function c36541439.chainlimit(e,ep,tp)
	return tp~=ep
end
--runic trigger
function c36541439.runicon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	return re:GetHandler():IsSetCard(0xba43) and (c:IsLocation(LOCATION_MZONE) or (c:IsLocation(LOCATION_SZONE) and ec)) and not Duel.IsExistingMatchingCard(c36541439.allow_tg,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and (re:GetHandler():GetFlagEffect(36541431)>0 
				or re:GetHandler():GetFlagEffect(36541432)>0
					or re:GetHandler():GetFlagEffect(36541433)>0 
						or re:GetHandler():GetFlagEffect(36541434)>0
							or re:GetHandler():GetFlagEffect(36541435)>0 
								or re:GetHandler():GetFlagEffect(36541436)>0)
end
function c36541439.runicost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(36541439)<=0 end
	e:GetHandler():RegisterFlagEffect(36541439,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c36541439.runictg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and (c:IsLocation(LOCATION_MZONE) or (c:IsLocation(LOCATION_SZONE) and ec)) end
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tspec=te:GetHandler()
		if tspec:IsSetCard(0xba43) then
			ng:AddCard(tspec)
		end
	end
	local d=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,ng:GetCount(),0,0)
	Duel.SetChainLimit(c36541439.chainlimit)
end
function c36541439.runicop(e,tp,eg,ep,ev,re,r,rp)
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tspec=te:GetHandler()
		if tspec:IsSetCard(0xba43) then
			ng:AddCard(tspec)
		end
	end
	if ng:GetCount()<=0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local d=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ng:GetCount(),nil)
	local dspec=d:Filter(Card.IsRelateToEffect,nil,e)
	if dspec:GetCount()>0 then
		Duel.Destroy(dspec,REASON_EFFECT)
	end
end
--kaim special condition--
--runic trigger
function c36541439.krunicon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	return re:GetHandler():IsSetCard(0xba43) and (c:IsLocation(LOCATION_MZONE) or (c:IsLocation(LOCATION_SZONE) and ec)) and Duel.IsExistingMatchingCard(c36541439.allow_tg,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and (re:GetHandler():GetFlagEffect(36541431)>0 
				or re:GetHandler():GetFlagEffect(36541432)>0
					or re:GetHandler():GetFlagEffect(36541433)>0 
						or re:GetHandler():GetFlagEffect(36541434)>0
							or re:GetHandler():GetFlagEffect(36541435)>0 
								or re:GetHandler():GetFlagEffect(36541436)>0)
end
function c36541439.krunicost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(36541439)<=0 end
	e:GetHandler():RegisterFlagEffect(36541439,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c36541439.krunictg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and (c:IsLocation(LOCATION_MZONE) or (c:IsLocation(LOCATION_SZONE) and ec)) end
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tspec=te:GetHandler()
		if tspec:IsSetCard(0xba43) then
			ng:AddCard(tspec)
		end
	end
	local d=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,ng:GetCount(),0,0)
	Duel.SetChainLimit(c36541439.chainlimit)
end
function c36541439.krunicop(e,tp,eg,ep,ev,re,r,rp)
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tspec=te:GetHandler()
		if tspec:IsSetCard(0xba43) then
			ng:AddCard(tspec)
		end
	end
	if ng:GetCount()<=0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local d=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ng:GetCount(),nil)
	Duel.SetTargetCard(d)
	if d:GetCount()>0 then
		Duel.Destroy(d,REASON_EFFECT)
	end
end