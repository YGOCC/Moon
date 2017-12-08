--Engraved Armament - Musubi
--Script by XGlitchy30
function c36541438.initial_effect(c)
	--runic trigger
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(36541438,0))
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetCondition(c36541438.runicon)
	e1:SetCost(c36541438.runicost)
	e1:SetTarget(c36541438.runictg)
	e1:SetOperation(c36541438.runicop)
	c:RegisterEffect(e1)
	--kaim special condition
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(36541438,0))
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetCondition(c36541438.krunicon)
	e2:SetCost(c36541438.krunicost)
	e2:SetTarget(c36541438.krunictg)
	e2:SetOperation(c36541438.krunicop)
	c:RegisterEffect(e2)
end
--filters
function c36541438.blockfilter(c)
	return c:IsType(TYPE_MONSTER) or (c:IsFacedown() and c:IsLocation(LOCATION_SZONE))
end
function c36541438.allow_tg(c)
	return c:GetFlagEffect(36541448)~=0
end
--values
function c36541438.chainlimit(e,ep,tp)
	return tp~=ep
end
--runic trigger
function c36541438.runicon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	return re:GetHandler():IsSetCard(0xba43) and (c:IsLocation(LOCATION_MZONE) or (c:IsLocation(LOCATION_SZONE) and ec)) and not Duel.IsExistingMatchingCard(c36541438.allow_tg,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and (re:GetHandler():GetFlagEffect(36541431)>0 
				or re:GetHandler():GetFlagEffect(36541432)>0
					or re:GetHandler():GetFlagEffect(36541433)>0 
						or re:GetHandler():GetFlagEffect(36541434)>0
							or re:GetHandler():GetFlagEffect(36541435)>0 
								or re:GetHandler():GetFlagEffect(36541436)>0)
end
function c36541438.runicost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(36541438)<=0 end
	e:GetHandler():RegisterFlagEffect(36541438,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c36541438.runictg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c36541438.blockfilter(chkc) end
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if chk==0 then return Duel.IsExistingTarget(c36541438.blockfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and (c:IsLocation(LOCATION_MZONE) or (c:IsLocation(LOCATION_SZONE) and ec)) end
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tspec=te:GetHandler()
		if tspec:IsSetCard(0xba43) then
			ng:AddCard(tspec)
		end
	end
	local blk=Duel.GetMatchingGroup(c36541438.blockfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetChainLimit(c36541438.chainlimit)
end
function c36541438.runicop(e,tp,eg,ep,ev,re,r,rp)
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tspec=te:GetHandler()
		if tspec:IsSetCard(0xba43) then
			ng:AddCard(tspec)
		end
	end
	if ng:GetCount()<=0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local neg=Duel.SelectTarget(tp,c36541438.blockfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ng:GetCount(),nil)
	local nspec=neg:Filter(Card.IsRelateToEffect,nil,e)
	if nspec:GetCount()>0 then
		local ntc=nspec:GetFirst()
		while ntc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			ntc:RegisterEffect(e1)
			if ntc:IsFacedown() and ntc:IsLocation(LOCATION_SZONE) then
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CANNOT_TRIGGER)
				e2:SetValue(1)
				e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				ntc:RegisterEffect(e2)
			end
			ntc=nspec:GetNext()
		end
	end
end
--kaim special condition--
--runic trigger
function c36541438.krunicon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	return re:GetHandler():IsSetCard(0xba43) and (c:IsLocation(LOCATION_MZONE) or (c:IsLocation(LOCATION_SZONE) and ec)) and Duel.IsExistingMatchingCard(c36541438.allow_tg,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and (re:GetHandler():GetFlagEffect(36541431)>0 
				or re:GetHandler():GetFlagEffect(36541432)>0
					or re:GetHandler():GetFlagEffect(36541433)>0 
						or re:GetHandler():GetFlagEffect(36541434)>0
							or re:GetHandler():GetFlagEffect(36541435)>0 
								or re:GetHandler():GetFlagEffect(36541436)>0)
end
function c36541438.krunicost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(36541438)<=0 end
	e:GetHandler():RegisterFlagEffect(36541438,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c36541438.krunictg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if chk==0 then return Duel.IsExistingMatchingCard(c36541438.blockfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and (c:IsLocation(LOCATION_MZONE) or (c:IsLocation(LOCATION_SZONE) and ec)) end
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tspec=te:GetHandler()
		if tspec:IsSetCard(0xba43) then
			ng:AddCard(tspec)
		end
	end
	local blk=Duel.GetMatchingGroup(c36541438.blockfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetChainLimit(c36541438.chainlimit)
end
function c36541438.krunicop(e,tp,eg,ep,ev,re,r,rp)
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tspec=te:GetHandler()
		if tspec:IsSetCard(0xba43) then
			ng:AddCard(tspec)
		end
	end
	if ng:GetCount()<=0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local neg=Duel.SelectMatchingCard(tp,c36541438.blockfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ng:GetCount(),nil)
	Duel.SetTargetCard(neg)
	if neg:GetCount()>0 then
		local ntc=neg:GetFirst()
		while ntc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			ntc:RegisterEffect(e1)
			if ntc:IsFacedown() and ntc:IsLocation(LOCATION_SZONE) then
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CANNOT_TRIGGER)
				e2:SetValue(1)
				e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				ntc:RegisterEffect(e2)
			end
			ntc=neg:GetNext()
		end
	end
end