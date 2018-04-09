--Engraved Armament - Tate
--Script by XGlitchy30
function c36541442.initial_effect(c)
	--runic trigger
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(36541442,0))
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetCondition(c36541442.runicon)
	e1:SetCost(c36541442.runicost)
	e1:SetTarget(c36541442.runictg)
	e1:SetOperation(c36541442.runicop)
	c:RegisterEffect(e1)
	--kaim special condition
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(36541442,0))
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetCondition(c36541442.krunicon)
	e2:SetCost(c36541442.runicost)
	e2:SetTarget(c36541442.krunictg)
	e2:SetOperation(c36541442.krunicop)
	c:RegisterEffect(e2)
end
--filters
function c36541442.allow_tg(c)
	return c:GetFlagEffect(36541448)~=0
end
--values
function c36541442.chainlimit(e,ep,tp)
	return tp~=ep
end
--runic trigger
function c36541442.runicon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	return re:GetHandler():IsSetCard(0xba43) and c:IsLocation(LOCATION_SZONE) and ec and not Duel.IsExistingMatchingCard(c36541442.allow_tg,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and (re:GetHandler():GetFlagEffect(36541431)>0 
				or re:GetHandler():GetFlagEffect(36541432)>0
					or re:GetHandler():GetFlagEffect(36541433)>0 
						or re:GetHandler():GetFlagEffect(36541434)>0
							or re:GetHandler():GetFlagEffect(36541435)>0 
								or re:GetHandler():GetFlagEffect(36541436)>0)
end
function c36541442.runicost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(36541442)<=0 end
	e:GetHandler():RegisterFlagEffect(36541442,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c36541442.runictg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and c:IsLocation(LOCATION_SZONE) and ec end
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tspec=te:GetHandler()
		if tspec:IsSetCard(0xba43) then
			ng:AddCard(tspec)
		end
	end
	local at=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,ec,1,0,0)
	Duel.SetChainLimit(c36541442.chainlimit)
end
function c36541442.runicop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
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
	local at=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,ng:GetCount(),nil)
	local atspec=at:Filter(Card.IsRelateToEffect,nil,e)
	local oppo=at:Filter(Card.IsControler,nil,1-tp)
	local opfirst=oppo:GetFirst()
	local opcount=oppo:GetCount()
	if atspec:GetCount()>0 then
		local atc=atspec:GetFirst()
		local ec=e:GetHandler():GetEquipTarget()
		Duel.ChangePosition(ec,POS_FACEUP_DEFENSE)
		local DEF=ng:GetCount()*300
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_EQUIP)
		e0:SetCode(EFFECT_UPDATE_DEFENSE)
		e0:SetValue(DEF)
		e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e0)
		while opfirst do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_MUST_ATTACK)
			e1:SetTargetRange(0,LOCATION_MZONE)
			e1:SetLabelObject(opfirst)
			e1:SetTarget(c36541442.attacker)
			e1:SetReset(RESET_PHASE+PHASE_BATTLE)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_MUST_ATTACK_MONSTER)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_MUST_BE_ATTACKED)
			e3:SetTargetRange(LOCATION_MZONE,0)
			e3:SetLabelObject(opfirst)
			e3:SetTarget(c36541442.attacked)
			e3:SetValue(c36541442.attacker)
			e3:SetReset(RESET_PHASE+PHASE_BATTLE)
			Duel.RegisterEffect(e3,tp)
			opfirst=oppo:GetNext()
		end
	end
end
function c36541442.attacked(e,c)
	return c==e:GetHandler():GetEquipTarget()
end
function c36541442.attacker(e,c)
	local tc=e:GetLabelObject()
	return c==tc
end
--kaim special condition--
--runic trigger
function c36541442.krunicon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	return re:GetHandler():IsSetCard(0xba43) and c:IsLocation(LOCATION_SZONE) and ec and Duel.IsExistingMatchingCard(c36541442.allow_tg,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and (re:GetHandler():GetFlagEffect(36541431)>0 
				or re:GetHandler():GetFlagEffect(36541432)>0
					or re:GetHandler():GetFlagEffect(36541433)>0 
						or re:GetHandler():GetFlagEffect(36541434)>0
							or re:GetHandler():GetFlagEffect(36541435)>0 
								or re:GetHandler():GetFlagEffect(36541436)>0)
end
function c36541442.krunictg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and c:IsLocation(LOCATION_SZONE) and ec end
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tspec=te:GetHandler()
		if tspec:IsSetCard(0xba43) then
			ng:AddCard(tspec)
		end
	end
	local at=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,ec,1,0,0)
	Duel.SetChainLimit(c36541442.chainlimit)
end
function c36541442.krunicop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
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
	local at=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,ng:GetCount(),nil)
	Duel.SetTargetCard(at)
	local oppo=at:Filter(Card.IsControler,nil,1-tp)
	local opfirst=oppo:GetFirst()
	local opcount=oppo:GetCount()
	if at:GetCount()>0 then
		local atc=at:GetFirst()
		local ec=e:GetHandler():GetEquipTarget()
		Duel.ChangePosition(ec,POS_FACEUP_DEFENSE)
		local DEF=ng:GetCount()*300
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_EQUIP)
		e0:SetCode(EFFECT_UPDATE_DEFENSE)
		e0:SetValue(DEF)
		e0:SetReset(RESET_EVENT+0x1fe0000)
		e:GetHandler():RegisterEffect(e0)
		while opfirst do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_MUST_ATTACK)
			e1:SetTargetRange(0,LOCATION_MZONE)
			e1:SetLabelObject(opfirst)
			e1:SetTarget(c36541442.attacker)
			e1:SetReset(RESET_PHASE+PHASE_BATTLE)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_MUST_ATTACK_MONSTER)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_MUST_BE_ATTACKED)
			e3:SetTargetRange(LOCATION_MZONE,0)
			e3:SetLabelObject(opfirst)
			e3:SetTarget(c36541442.attacked)
			e3:SetValue(c36541442.attacker)
			e3:SetReset(RESET_PHASE+PHASE_BATTLE)
			Duel.RegisterEffect(e3,tp)
			opfirst=oppo:GetNext()
		end
	end
end