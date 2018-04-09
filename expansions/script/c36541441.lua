--Engraved Armament - Ken
--Script by XGlitchy30
function c36541441.initial_effect(c)
	--runic trigger
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(36541441,0))
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetCondition(c36541441.runicon)
	e1:SetCost(c36541441.runicost)
	e1:SetTarget(c36541441.runictg)
	e1:SetOperation(c36541441.runicop)
	c:RegisterEffect(e1)
	--kaim special condition
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(36541441,0))
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetCondition(c36541441.krunicon)
	e2:SetCost(c36541441.runicost)
	e2:SetTarget(c36541441.krunictg)
	e2:SetOperation(c36541441.krunicop)
	c:RegisterEffect(e2)
end
--filters
function c36541441.allow_tg(c)
	return c:GetFlagEffect(36541448)~=0
end
--values
function c36541441.chainlimit(e,ep,tp)
	return tp~=ep
end
--runic trigger
function c36541441.runicon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	return re:GetHandler():IsSetCard(0xba43) and c:IsLocation(LOCATION_SZONE) and ec and not Duel.IsExistingMatchingCard(c36541441.allow_tg,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and (re:GetHandler():GetFlagEffect(36541431)>0 
				or re:GetHandler():GetFlagEffect(36541432)>0
					or re:GetHandler():GetFlagEffect(36541433)>0 
						or re:GetHandler():GetFlagEffect(36541434)>0
							or re:GetHandler():GetFlagEffect(36541435)>0 
								or re:GetHandler():GetFlagEffect(36541436)>0)
end
function c36541441.runicost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(36541441)<=0 end
	e:GetHandler():RegisterFlagEffect(36541441,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c36541441.runictg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
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
	Duel.SetChainLimit(c36541441.chainlimit)
end
function c36541441.runicop(e,tp,eg,ep,ev,re,r,rp)
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
		Duel.ChangePosition(ec,POS_FACEUP_ATTACK)
		local ATK=ng:GetCount()*300
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(ATK)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e2)
		while opfirst do
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
			e0:SetCondition(c36541441.fixcon)
			e0:SetValue(opcount)
			e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
			ec:RegisterEffect(e0)
			local e3=Effect.CreateEffect(c)
			e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
			e3:SetRange(LOCATION_MZONE)
			e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e3:SetCondition(c36541441.fixcon)
			e3:SetTarget(c36541441.attacktarget)
			e3:SetLabelObject(opfirst)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
			e3:SetValue(1)
			ec:RegisterEffect(e3)
			opfirst=oppo:GetNext()
		end
	end
end
function c36541441.fixcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackedCount()>0
end
function c36541441.attacktarget(e,c)
	local attack=Duel.GetAttacker()
	local opfirst=e:GetLabelObject()
	if not attack or attack~=e:GetHandler() then return false end
	return c~=opfirst
end
--kaim special condition--
--runic trigger
function c36541441.krunicon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	return re:GetHandler():IsSetCard(0xba43) and c:IsLocation(LOCATION_SZONE) and ec and Duel.IsExistingMatchingCard(c36541441.allow_tg,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and (re:GetHandler():GetFlagEffect(36541431)>0 
				or re:GetHandler():GetFlagEffect(36541432)>0
					or re:GetHandler():GetFlagEffect(36541433)>0 
						or re:GetHandler():GetFlagEffect(36541434)>0
							or re:GetHandler():GetFlagEffect(36541435)>0 
								or re:GetHandler():GetFlagEffect(36541436)>0)
end
function c36541441.krunictg(e,tp,eg,ep,ev,re,r,rp,chk)
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
	Duel.SetChainLimit(c36541441.chainlimit)
end
function c36541441.krunicop(e,tp,eg,ep,ev,re,r,rp)
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
		Duel.ChangePosition(ec,POS_FACEUP_ATTACK)
		local ATK=ng:GetCount()*300
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(ATK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e:GetHandler():RegisterEffect(e2)
		while opfirst do
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
			e0:SetCondition(c36541441.fixcon)
			e0:SetValue(opcount)
			e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
			ec:RegisterEffect(e0)
			local e3=Effect.CreateEffect(c)
			e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
			e3:SetRange(LOCATION_MZONE)
			e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e3:SetCondition(c36541441.fixcon)
			e3:SetTarget(c36541441.attacktarget)
			e3:SetLabelObject(opfirst)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
			e3:SetValue(1)
			ec:RegisterEffect(e3)
			opfirst=oppo:GetNext()
		end
	end
end