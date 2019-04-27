--G.O.D.
--scripted by ChaosBladesIX[EW]
function c24680135.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
    --destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24680135,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c24680135.pdescon)
	e1:SetTarget(c24680135.pdestg)
	e1:SetOperation(c24680135.pdesop)
	c:RegisterEffect(e1)
    --indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	------------------------------------------------------------
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(24680135,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)	
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetCode(EVENT_PHASE+PHASE_DRAW)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c24680135.atkop)
	c:RegisterEffect(e3)
	--target
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(84565800,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetTarget(c24680135.negtg)
	e4:SetOperation(c24680135.negop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(20374351,1))
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c24680135.discon)
	e5:SetTarget(c24680135.distg)
	e5:SetOperation(c24680135.disop)
	c:RegisterEffect(e5)
    --destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(24680135,2))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c24680135.descon)
	e6:SetTarget(c24680135.destg)
	e6:SetOperation(c24680135.desop)
	c:RegisterEffect(e6)
end
--(Pendulum Effects are currently unconfirmed)
--Is presumed that G.O.D. is Divine/Divine-Beast and their Pendulum Scales are 13
function c24680135.cfilter(c)--destroy ms on the field up to the n of cs in your Pzones functions
	return (c:IsFaceup() or c:IsFacedown())
end
function c24680135.pdescon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c24680135.cfilter,tp,LOCATION_PZONE,0,1,nil)
end
function c24680135.pdestg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_PZONE,LOCATION_PZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c24680135.pdesop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c24680135.cfilter,tp,LOCATION_PZONE,0,nil)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
---------------------------------------------------------
function c24680135.atkop(e,tp,eg,ep,ev,re,r,rp)--gain atk function
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
end
function c24680135.pcfilter(c)--if targeted by battle; you can negate attack + end turn functions
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c24680135.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
	and Duel.IsExistingMatchingCard(c24680135.pcfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
end
function c24680135.negop(e,tp,eg,ep,ev,re,r,rp)
    --Pendulum Sequence
    if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c24680135.pcfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	--negateattack sequence
	local c=e:GetHandler()
	Duel.NegateAttack()
	if c:IsRelateToEffect(e) then
		Duel.BreakEffect()--move to field subsequence
		if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		--end turn subsequence
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	    Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		end
	end
end
function c24680135.discon(e,tp,eg,ep,ev,re,r,rp)--if targeted by an effect; you can negate it + end turn functions
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(c) and Duel.IsChainDisablable(ev)
end
function c24680135.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
	and Duel.IsExistingMatchingCard(c24680135.pcfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c24680135.disop(e,tp,eg,ep,ev,re,r,rp)
    --Pendulum Sequence
    if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c24680135.pcfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	--negateeffect sequence
	local c=e:GetHandler()
	Duel.NegateEffect(ev)
	if c:IsRelateToEffect(e) then
		Duel.BreakEffect()--move to field subsequence
		if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		--end turn subsequence
		Duel.SkipPhase(1-tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	    Duel.SkipPhase(1-tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	    Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	    Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	    Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	    local e1=Effect.CreateEffect(e:GetHandler())
	    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	    e1:SetType(EFFECT_TYPE_FIELD)
	    e1:SetCode(EFFECT_CANNOT_BP)
	    e1:SetTargetRange(0,1)
	    e1:SetReset(RESET_PHASE+PHASE_END)
	    Duel.RegisterEffect(e1,tp)
		end
	end
end
function c24680135.filter(c)--destroy ms on the field up to the n of cs in your Pzones functions
	return (c:IsFaceup() or c:IsFacedown())
end
function c24680135.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c24680135.filter,tp,LOCATION_PZONE,0,1,nil)
end
function c24680135.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_PZONE,LOCATION_PZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c24680135.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c24680135.filter,tp,LOCATION_PZONE,0,nil)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
