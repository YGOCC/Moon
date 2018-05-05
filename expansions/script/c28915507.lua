--Goyo Gardna
--Design by Shadowshocker, Code by Kinny
local ref=_G['c'..28915507]
function ref.initial_effect(c)
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_ADJUST)
	ge1:SetRange(0xff)
	ge1:SetCountLimit(1,555+EFFECT_COUNT_CODE_DUEL)
	ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	ge1:SetOperation(ref.chk)
	c:RegisterEffect(ge1,tp)
	--Negate Battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(ref.ngcon1)
	e1:SetOperation(ref.ngop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(ref.ngcon2)
	e2:SetTarget(ref.ngtg2)
	e2:SetOperation(ref.ngop2)
	c:RegisterEffect(e2)
	--Float
	local e2=Effect.CreateEffect(c)
	--e2:SetType(
end
ref.burst=true
function ref.trapmaterial(c)
	return true
end
function ref.monmaterial(c)
	return true
end
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,555,nil,nil,nil,nil,nil,nil)		
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.Remove(token,POS_FACEUP,REASON_RULE)
end

function ref.ngcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE and not Duel.CheckEvent(EVENT_CHAINING)
end
function ref.ngop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end

function ref.ngcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE
end
function ref.ngtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		ng:AddCard(tc)
	end
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
end
function ref.ngop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	for i=1,ev do
		Duel.NegateActivation(i)
	end
end