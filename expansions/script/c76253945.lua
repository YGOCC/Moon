--Jewelry of Mystical Elves
--Script by XGlitchy30
function c76253945.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c76253945.target)
	e1:SetOperation(c76253945.operation)
	c:RegisterEffect(e1)
	--Untargetable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e2x=Effect.CreateEffect(c)
	e2x:SetType(EFFECT_TYPE_EQUIP)
	e2x:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2x:SetValue(1)
	c:RegisterEffect(e2x)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c76253945.eqlimit)
	c:RegisterEffect(e3)
	--protection
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_F)
	--e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c76253945.pcon1)
	e4:SetTarget(c76253945.ptg)
	e4:SetOperation(c76253945.pop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_CHAINING)
	e5:SetCondition(c76253945.pcon2)
	c:RegisterEffect(e5)
	--place counter
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_RECOVER)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1,76253945)
	e6:SetCost(aux.bfgcost)
	e6:SetTarget(c76253945.cttg)
	e6:SetOperation(c76253945.ctop)
	c:RegisterEffect(e6)
end
--equip limit
function c76253945.eqlimit(e,c)
	return c:IsSetCard(0x7634)
end
--filters
function c76253945.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x7634)
end
function c76253945.eqfilter(c,eq)
	return c==eq
end
function c76253945.stfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c76253945.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
--Activate
function c76253945.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c76253945.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c76253945.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c76253945.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c76253945.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
--protection
--BATTLE CONDITION--
function c76253945.pcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetEquipTarget()
	local tc=Duel.GetAttacker()
	local bc=tc:GetBattleTarget()
	if not eq then return false end
	if tc:IsControler(1-tp) then
		tc=Duel.GetAttackTarget()
		bc=Duel.GetAttacker()
	end
	if not tc or not bc or tc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then return false end
	e:SetLabelObject(tc)
	if bc==Duel.GetAttackTarget() and bc:IsDefensePos() then return false end
	if bc:IsPosition(POS_FACEUP_DEFENSE) and bc==Duel.GetAttacker() then
		if not bc:IsHasEffect(EFFECT_DEFENSE_ATTACK) then return false end
		if bc:IsHasEffect(EFFECT_DEFENSE_ATTACK) then
			if bc:GetEffectCount(EFFECT_DEFENSE_ATTACK)==1 then
				if tc:IsAttackPos() then
					if bc:GetDefense()==tc:GetAttack() and not bc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
						return bc:GetDefense()~=0
					else
						return bc:GetDefense()>=tc:GetAttack()
					end
				else
					return bc:GetDefense()>tc:GetDefense()
				end
			elseif bc:IsHasEffect(EFFECT_DEFENSE_ATTACK) then
				if tc:IsAttackPos() then
					if bc:GetAttack()==tc:GetAttack() and not bc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
						return bc:GetAttack()~=0
					else
						return bc:GetAttack()>=tc:GetAttack()
					end
				else
					return bc:GetAttack()>tc:GetDefense()
				end
			end
		end
	else
		if tc:IsAttackPos() then
			if bc:GetAttack()==tc:GetAttack() and not bc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
				return bc:GetAttack()~=0
			else
				return bc:GetAttack()>=tc:GetAttack()
			end
		else
			return bc:GetAttack()>tc:GetDefense()
		end
	end
end
--EFFECT CONDITION--
function c76253945.pcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetEquipTarget()
	if not eq then return end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	if ex and tg~=nil then
		local g=tg:Filter(c76253945.eqfilter,nil,eq)
		e:SetLabelObject(g:GetFirst())
		return true
	end
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	if ex and tg~=nil then
		local g=tg:Filter(c76253945.eqfilter,nil,eq)
		e:SetLabelObject(g:GetFirst())
		return true
	end
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	if ex and tg~=nil then
		local g=tg:Filter(c76253945.eqfilter,nil,eq)
		e:SetLabelObject(g:GetFirst())
		return true
	end
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TODECK)
	if ex and tg~=nil then
		local g=tg:Filter(c76253945.eqfilter,nil,eq)
		e:SetLabelObject(g:GetFirst())
		return true
	end
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_RELEASE)
	if ex and tg~=nil then
		local g=tg:Filter(c76253945.eqfilter,nil,eq)
		e:SetLabelObject(g:GetFirst())
		return true
	end
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
	if ex and tg~=nil then
		local g=tg:Filter(c76253945.eqfilter,nil,eq)
		e:SetLabelObject(g:GetFirst())
		return true
	end
	return false
end
--protection effect
function c76253945.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if chk==0 then return tc and c end
	Duel.SetTargetCard(tc)
end
function c76253945.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc then
		--
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetReset(RESET_CHAIN)
		e2:SetValue(c76253945.efilter)
		tc:RegisterEffect(e2)
		--
		if Duel.Destroy(c,REASON_EFFECT)~=0 then
			if not Duel.IsExistingMatchingCard(c76253945.stfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then return end
			if Duel.SelectYesNo(tp,aux.Stringid(76253945,0)) then
				local tg=Duel.SelectTarget(tp,c76253945.stfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
				if tg:GetCount()>0 then
					Duel.Destroy(tg,REASON_EFFECT)
				end
			end
		end		
	end
end
--place counter
function c76253945.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end 
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x1049,1)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)
end
function c76253945.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if tc:AddCounter(0x1049,1)~=0 then
			Duel.Recover(tp,800,REASON_EFFECT)	
		end
	end
end