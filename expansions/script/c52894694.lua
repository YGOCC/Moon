--Des Beast
--Scripted by Kedy
--Concept by XStutzX
local function ID()
    local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
    str=string.sub(str,1,string.len(str)-4)
    local cod=_G[str]
    local id=tonumber(string.sub(str,2))
    return id,cod
end

local id,cod=ID()
function cod.initial_effect(c)
	--Synchro Summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,1)
	--Cannot be battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(function (e,c) return c:IsCode(52894693) end)
	c:RegisterEffect(e1)
	--Cannot be effect target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,52894693))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Cannot be destroyed
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,52894693))
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(cod.spcon)
	e4:SetCost(cod.spcost)
	e4:SetTarget(cod.sptg)
	e4:SetOperation(cod.spop)
	c:RegisterEffect(e4)
	--Custom Attack Counter
	Duel.AddCustomActivityCounter(id,ACTIVITY_ATTACK,cod.counterfilter)
end

--Custom Attack Count
function cod.counterfilter(c)
	return not c:IsCode(52894693)
end

--Special Summon
function cod.mfilter(c)
	return c:GetCode()==52894693 and c:IsPosition(POS_FACEUP_ATTACK)
end
function cod.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_CHAINING) 
		and Duel.GetCustomActivityCount(id,tp,ACTIVITY_ATTACK)==0
		and Duel.IsExistingMatchingCard(cod.mfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cod.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cod.mfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINT_SELECTMSG)
	local g=Duel.SelectMatchingCard(tp,cod.mfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
end
function cod.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cod.efilter(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:GetCode()==52894693
end
function cod.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local ph=Duel.GetCurrentPhase()
		if (ph>=8 or ph<=80) and Duel.GetAttackTarget() then
			if Duel.GetAttackTarget():GetCode()==52894693 then
				Duel.NegateAttack()
			end 
		end
		if Duel.GetCurrentChain()>1 then
			local cv=Duel.GetCurrentChain()-1
			for i=1,cv do
				local tg=Duel.GetChainInfo(i,CHAININFO_TARGET_CARDS)
				if tg and tg:IsExists(cod.efilter,1,nil) then
					Duel.NegateEffect(i)
				end
			end
		end
	end
	--Return to Extra
	local ph=Duel.GetCurrentPhase()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabel(ph)
	e1:SetOperation(cod.regop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end

--Return
function cod.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pv=e:GetLabel()
	local ph=Duel.GetCurrentPhase()
	if pv>=0x8 and pv<=0x80 then
		if ph>0x80 and ph<=0x100 then
			Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
			e:SetLabel(0)
		end
	elseif ph~=pv then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
		e:SetLabel(0)
	end
end