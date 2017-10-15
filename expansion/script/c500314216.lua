--Supa-Paintress Archer Turkia
--Created by Chadook
--Scripted by Chadook
function c500314216.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
		local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(500314216,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,500314216)
	e1:SetCondition(c500314216.drcon)
	e1:SetTarget(c500314216.drtg)
	e1:SetOperation(c500314216.drop)
	c:RegisterEffect(e1)
		--disable attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(500314216,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_ATTACK)
	e2:SetRange(LOCATION_GRAVE)
e2:SetCondition(c500314216.condition)
	e2:SetCost(c500314216.cost)
	e2:SetOperation(c500314216.operation)
	c:RegisterEffect(e2)
	if not c500314216.global_check then
		c500314216.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c500314216.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c500314216.evolute=true
c500314216.material1=function(mc) return  mc:IsType(TYPE_NORMAL) and mc:GetLevel()==3 and mc:IsFaceup() end
c500314216.material2=function(mc) return mc:IsType(TYPE_NORMAL) and mc:GetLevel()==3 and mc:IsFaceup() end
function c500314216.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,388)
	Duel.CreateToken(1-tp,388)
			c500314216.stage_o=6
c500314216.stage=c500314216.stage_o
end
function c500314216.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+388
end
function c500314216.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=3-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c500314216.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=3-Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if ct>0 then
		Duel.Draw(p,ct,REASON_EFFECT)
	end
	end

function c500314216.condition(e,tp,eg,ep,ev,re,r,rp)
	return  (Duel.IsAbleToEnterBP() or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE))
end
function c500314216.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c500314216.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker() then Duel.NegateAttack()
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(c500314216.disop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c500314216.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,500314216)
	Duel.NegateAttack()
end