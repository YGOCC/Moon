-- Bonds Between Driver & Blade

function c50000062.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,50000062+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c50000062.condition)
	e1:SetTarget(c50000062.target)
	e1:SetOperation(c50000062.activate)
	c:RegisterEffect(e1)
end

function c50000062.filter(c,tp)
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetReasonPlayer()~=tp
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
		and c:GetPreviousControler()==tp and c:IsControler(tp) and c:IsRace(RACE_FAIRY) and c:IsLevelAbove(8)
end
function c50000062.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c50000062.filter,1,nil,tp)
end
function c50000062.filter2(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c50000062.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c50000062.filter2,tp,LOCATION_MZONE,0,1,nil) end
end
function c50000062.filter3(c,e)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_WATER) and not c:IsImmuneToEffect(e)
end
function c50000062.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c50000062.filter3,tp,LOCATION_MZONE,0,nil,e)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end