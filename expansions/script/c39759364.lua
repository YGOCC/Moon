--Difensore Scoppio
--Script by XGlitchy30
function c39759364.initial_effect(c)
	--Deck Master
	aux.AddOrigDeckmasterType(c)
	aux.EnableDeckmaster(c,nil,nil,c39759364.mscon,nil,nil,c39759364.penalty)
	--Ability: Reaction Blast
	local ab=Effect.CreateEffect(c)
	ab:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	ab:SetCategory(CATEGORY_DESTROY)
	ab:SetType(EFFECT_TYPE_QUICK_O)
	ab:SetCode(EVENT_ATTACK_ANNOUNCE)
	ab:SetRange(LOCATION_SZONE)
	ab:SetCountLimit(1)
	ab:SetCondition(c39759364.atcon)
	ab:SetTarget(c39759364.attg)
	ab:SetOperation(c39759364.atop)
	c:RegisterEffect(ab)
	--Monster Effects--
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--give battle effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(c:GetOriginalCode(),2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,c:GetOriginalCode())
	e2:SetCondition(c39759364.tgcon)
	e2:SetTarget(c39759364.tgtg)
	e2:SetOperation(c39759364.tgop)
	c:RegisterEffect(e2)
	--Turn Check
	if not c39759364.global_check then
		c39759364.global_check=true
		c39759364[0]=0
		c39759364[1]=0
		local reg=Effect.CreateEffect(c)
		reg:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		reg:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		reg:SetCode(EVENT_DAMAGE)
		reg:SetCondition(c39759364.regdamcon)
		reg:SetOperation(c39759364.regdam)
		Duel.RegisterEffect(reg,0)
		local reg2=Effect.CreateEffect(c)
		reg2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		reg2:SetCode(EVENT_TURN_END)
		reg2:SetCountLimit(1)
		reg2:SetOperation(c39759364.regturn)
		Duel.RegisterEffect(reg2,0)
	end
end
c39759364.turn={[0]=0;[1]=0}
--filters
function c39759364.cgfilter(c,tp)
	return c:IsFaceup() and c:IsAttackPos() and c:GetSummonPlayer()==tp
end
function c39759364.attacker(c)
	return c:IsFaceup() and c:IsAttackable() and not c:IsHasEffect(EFFECT_DIRECT_ATTACK)
end
function c39759364.filter(c)
	return c:IsFaceup() and c:GetFlagEffect(39759364)==0
end
--Turn Check
function c39759364.regdamcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(ep,39759364)==0
end
function c39759364.regdam(e,tp,eg,ep,ev,re,r,rp)
	c39759364[ep] = c39759364[ep]+ev
	if c39759364[ep]>1000 then
		Duel.RegisterFlagEffect(ep,39759364,RESET_EVENT+EVENT_CUSTOM+39759364,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE,1)
	end
end
function c39759364.regturn(e,tp,eg,ep,ev,re,r,rp)
	local self=Duel.GetFlagEffect(tp,39759364)
	local oppo=Duel.GetFlagEffect(1-tp,39759364)
	if self==0 then
		c39759364.turn[tp] = c39759364.turn[tp]+1
		if e:GetHandler():IsControler(tp) and aux.CheckDMActivatedState(e) then
			e:GetHandler():SetTurnCounter(c39759364.turn[tp])
		end
	else
		c39759364.turn[tp] = 0
		c39759364[tp] = 0
		Duel.ResetFlagEffect(tp,39759364)
	end
	if oppo then
		c39759364.turn[1-tp] = c39759364.turn[1-tp]+1
		if e:GetHandler():IsControler(1-tp) and aux.CheckDMActivatedState(e) then
			e:GetHandler():SetTurnCounter(c39759364.turn[1-tp])
		end
	else
		c39759364.turn[1-tp] = 0
		c39759364[1-tp] = 0
		Duel.ResetFlagEffect(1-tp,39759364)
	end
end		
--Deck Master Functions
function c39759364.DMCost(e,tp,eg,ep,ev,re,r,rp)
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetOperation(c39759364.changeop)
	Duel.RegisterEffect(e0,tp)
	local e1=e0:Clone()
	e1:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	Duel.RegisterEffect(e1,tp)
	local e2=e0:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c39759364.limittg)
	Duel.RegisterEffect(e3,tp)
end
function c39759364.changeop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c39759364.cgfilter,nil,tp)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)	
end
function c39759364.limittg(e,c)
	return c:IsStatus(STATUS_SUMMON_TURN+STATUS_FLIP_SUMMON_TURN+STATUS_SPSUMMON_TURN) and c:IsType(TYPE_LINK)
end
function c39759364.mscon(e,c)
	return c39759364.turn[c:GetControler()]>=5
end
function c39759364.penalty(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetCountLimit(1)
	e1:SetCondition(c39759364.bscon)
	e1:SetOperation(c39759364.bsop)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function c39759364.bscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.IsExistingMatchingCard(c39759364.attacker,tp,0,LOCATION_MZONE,1,nil)
end
function c39759364.bsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(1-tp,c39759364.attacker,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsFaceup() then
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
--Ability: Reaction Blast
function c39759364.atcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.CheckDMActivatedState(e) and Duel.GetAttacker():IsControler(1-tp)
end
function c39759364.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttacker():IsRelateToBattle() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetAttacker(),1,0,0)
end
function c39759364.atop(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.GetAttacker()
	if dc:IsRelateToBattle() then
		Duel.Destroy(dc,REASON_EFFECT)
	end
end
--Monster Effects--
--give battle effects
function c39759364.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()<PHASE_MAIN2
end
function c39759364.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c8529136.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c39759364.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c39759364.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c39759364.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:GetFlagEffect(39759364)==0 then
			tc:RegisterFlagEffect(39759364,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLED)
		e1:SetCondition(c39759364.drycon)
		e1:SetOperation(c39759364.dryop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c39759364.drycon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	return tc and tc:IsRelateToBattle() and e:GetOwnerPlayer()==tp
end
function c39759364.dryop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	Duel.Hint(HINT_CARD,0,39759364)
	Duel.Destroy(tc,REASON_EFFECT)
end