--Wyrm of Fiber Vine 
function c160002123.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--splimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetTargetRange(1,0)
	e6:SetTarget(c160002123.splimit)
	e6:SetCondition(c160002123.splimcon)
	c:RegisterEffect(e6)

		-- destroy & damage
	--local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(160002123,0))
	--e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	--e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e1:SetType(EFFECT_TYPE_IGNITION)
	--e1:SetRange(LOCATION_MZONE)
	--e1:SetCountLimit(1)
	--e1:SetCost(c160002123.cost)
	--e1:SetTarget(c160002123.target)
	--e1:SetOperation(c160002123.operation)
	--c:RegisterEffect(e1)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(160002123,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c160002123.eqcon)
	e1:SetTarget(c160002123.eqtg)
	e1:SetOperation(c160002123.eqop)
	c:RegisterEffect(e1)
		--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	--Negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(160002123,1))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c160002123.condition)
	e4:SetCost(c160002123.cost)
	e4:SetTarget(c160002123.target)
	e4:SetOperation(c160002123.operation)
	c:RegisterEffect(e4)
end

function c160002123.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x185a) or c:IsRace(RACE_PLANT) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c160002123.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c160002123.cfilter(c)
	return c:IsSetCard(0x185a) and c:IsAbleToRemoveAsCost()
end

--function c160002123.cost(e,tp,eg,ep,ev,re,r,rp,chk)
--	local c=e:GetHandler()
--	if chk==0 then return c:GetAttackAnnouncedCount()==0 end
--	local e1=Effect.CreateEffect(c)
---	e1:SetType(EFFECT_TYPE_SINGLE)
--	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
--	e1:SetCode(EFFECT_CANNOT_ATTACK)
--	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
--	c:RegisterEffect(e1,true)
--	c:RegisterFlagEffect(160002123,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
--end
--function c160002123.filter(c)
--	return  c:IsDestructable()
--end
--function c160002123.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
--	if chk==0 then return Duel.IsExistingMatchingCard(c160002123.filter,tp,0,LOCATION_MZONE,1,nil) end
--	local g=Duel.GetMatchingGroup(c160002123.filter,tp,0,LOCATION_MZONE,nil)
--	local tg=g:GetMaxGroup(Card.GetAttack)
--	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
--end
--function c160002123.operation(e,tp,eg,ep,ev,re,r,rp)
--	local g=Duel.GetMatchingGroup(c160002123.filter,tp,0,LOCATION_MZONE,nil)
--	if g:GetCount()>0 then
--	local tg=g:GetMaxGroup(Card.GetAttack)
--	local dam=tg:GetFirst():GetAttack()
--		if tg:GetCount()>1 then
--			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
--			local sg=tg:Select(tp,1,1,nil)
--			Duel.HintSelection(sg)
--			local dam1=sg:GetFirst():GetAttack()
--			if Duel.Destroy(sg,REASON_EFFECT)~=0 then
--				Duel.Damage(1-tp,dam1,REASON_EFFECT)
--			end
	--	else
--			if Duel.Destroy(tg,REASON_EFFECT)~=0 then
--				Duel.Damage(1-tp,dam,REASON_EFFECT)
--			end
--		end
--	end
--end
function c160002123.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=e:GetLabelObject()
	return ec==nil or ec:GetFlagEffect(160002123)==0
end
function c160002123.xfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0 and c:IsAbleToChangeControler()
end
function c160002123.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp)  end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c160002123.xfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c160002123.xfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c160002123.eqlimit(e,c)
	return e:GetOwner()==c
end
function c160002123.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local atk=tc:GetTextAttack()/2
			local def=tc:GetTextDefense()/2
			if tc:IsFacedown() or atk<0 then atk=0 end
			if tc:IsFacedown() or def<0 then def=0 end
			if not Duel.Equip(tp,tc,c,false) then return end
			--Add Equip limit
			tc:RegisterFlagEffect(160002123,RESET_EVENT+0x1fe0000,0,0)
			e:SetLabelObject(tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c160002123.eqlimit)
			tc:RegisterEffect(e1)
			if atk>0 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				e2:SetValue(atk)
				tc:RegisterEffect(e2)
			end
			--if def>0 then
				--local e3=Effect.CreateEffect(c)
				--e3:SetType(EFFECT_TYPE_EQUIP)
				--e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
				--e3:SetCode(EFFECT_UPDATE_DEFENSE)
				--e3:SetReset(RESET_EVENT+0x1fe0000)
				--e3:SetValue(def)
				--tc:RegisterEffect(e3)
			--end
	end
end
end
function c160002123.condition(e,tp,eg,ep,ev,re,r,rp)
	return  re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c160002123.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	   if chk==0 then return Duel.IsExistingMatchingCard(c160002123.cfilter,tp,LOCATION_GRAVE,0,1,nil) and  Duel.CheckLPCost(tp,1000) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,c160002123.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
	Duel.PayLPCost(tp,1000)
end
function c160002123.cfilter(c)
	return  c:IsFaceup() and   c:IsRace(RACE_PLANT)  and c:IsAbleToRemoveAsCost()
end
function c160002123.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c160002123.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()~=ev+1 then return	end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
	end