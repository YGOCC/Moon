--Cacciatore dell'Oltremondo & Lucchetto Arrugginito
--Script by XGlitchy30
function c39759373.initial_effect(c)
	--Deck Master
	aux.AddOrigDeckmasterType(c)
	aux.EnableDeckmaster(c,nil,nil,c39759373.mscon,c39759373.mscustom,c39759373.penaltycon,c39759373.penalty)
	--Ability: Ghost Slayer
	local ab=Effect.CreateEffect(c)
	ab:SetDescription(aux.Stringid(c:GetOriginalCode(),1))
	ab:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ab:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	ab:SetCode(EVENT_DISCARD)
	ab:SetRange(LOCATION_SZONE)
	ab:SetCondition(c39759373.condition)
	ab:SetOperation(c39759373.operation)
	c:RegisterEffect(ab)
	--Monster Effects--
	--negate traps
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e2:SetTarget(c39759373.distarget)
	c:RegisterEffect(e2)
	--disable effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c39759373.disoperation)
	c:RegisterEffect(e3)
end
--filters
function c39759373.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and c:GetPreviousControler()==1-tp and c:IsReason(REASON_COST)
end
function c39759373.thfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsType(TYPE_MONSTER) and c:GetDefense()==1800 and c:IsAbleToHand()
end
function c39759373.costfilter(c,ft)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) and c:IsRace(RACE_ZOMBIE) and c:GetLevel()==3 and c:IsAbleToRemoveAsCost() and (ft>0 or c:GetSequence()<5)
end
--Deck Master Functions
function c39759373.DMCost(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_DISABLED)
	e1:SetCondition(c39759373.regnegcon)
	e1:SetOperation(c39759373.regneg)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c39759373.accon_m)
	e2:SetValue(c39759373.aclimit_m)
	Duel.RegisterEffect(e2,tp)
	local e2x=Effect.CreateEffect(e:GetHandler())
	e2x:SetType(EFFECT_TYPE_FIELD)
	e2x:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2x:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2x:SetTargetRange(1,0)
	e2x:SetCondition(c39759373.accon_s)
	e2x:SetValue(c39759373.aclimit_s)
	Duel.RegisterEffect(e2x,tp)
	local e2y=Effect.CreateEffect(e:GetHandler())
	e2y:SetType(EFFECT_TYPE_FIELD)
	e2y:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2y:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2y:SetTargetRange(1,0)
	e2y:SetCondition(c39759373.accon_t)
	e2y:SetValue(c39759373.aclimit_t)
	Duel.RegisterEffect(e2y,tp)
end
function c39759373.regnegcon(e,tp,eg,ep,ev,re,r,rp)
	local dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_PLAYER)
	return dp==tp and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end
function c39759373.regneg(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) then
		Duel.RegisterFlagEffect(tp,39759373,RESET_PHASE+PHASE_END,0,1)
	end
	if re:IsActiveType(TYPE_SPELL) then
		Duel.RegisterFlagEffect(tp,30759373,RESET_PHASE+PHASE_END,0,1)
	end
	if re:IsActiveType(TYPE_TRAP) then
		Duel.RegisterFlagEffect(tp,31759373,RESET_PHASE+PHASE_END,0,1)
	end
end
function c39759373.mscon(e,c)
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c39759373.costfilter,tp,LOCATION_MZONE,0,1,nil,ft)
end
function c39759373.mscustom(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c39759373.costfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c39759373.penaltycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c39759373.thfilter,tp,0,LOCATION_DECK+LOCATION_GRAVE,1,nil)
end
function c39759373.penalty(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(1-tp,aux.Stringid(39759373,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(1-tp,aux.NecroValleyFilter(c39759373.thfilter),tp,0,LOCATION_DECK+LOCATION_GRAVE,1,2,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,1-tp,REASON_EFFECT)
			Duel.ConfirmCards(tp,g)
		end
	end
end
--DMCost functions
function c39759373.accon_m(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,39759373)>0
end
function c39759373.accon_s(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,30759373)>0
end
function c39759373.accon_t(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,31759373)>0
end
function c39759373.aclimit_m(e,re,tp)
	return re:GetHandler():IsType(TYPE_MONSTER)
end
function c39759373.aclimit_s(e,re,tp)
	return re:GetHandler():IsType(TYPE_SPELL)
end
function c39759373.aclimit_t(e,re,tp)
	return re:GetHandler():IsType(TYPE_TRAP)
end
--Ability: Ghost Slayer
function c39759373.condition(e,tp,eg,ep,ev,re,r,rp)
	return re and rp==1-tp and re:IsHasType(0x7f0) and eg:IsExists(c39759373.cfilter,1,nil,tp) and Duel.IsChainDisablable(ev) and aux.CheckDMActivatedState(e)
end
function c39759373.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsDisabled() then
		Duel.Hint(HINT_CARD,tp,39759373)
		if Duel.NegateEffect(ev) then
			if not tc:IsAbleToRemove() then return end
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
				if e:GetHandler():GetFlagEffect(39759373)>0 or not Duel.IsPlayerCanDraw(tp,1) then return end
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
		e:GetHandler():RegisterFlagEffect(39759373,RESET_PHASE+PHASE_END,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE,1)
	end
end
--Monster Effects--
--negate traps
function c39759373.distarget(e,c)
	return c~=e:GetHandler() and c:IsType(TYPE_TRAP)
end
function c39759373.disoperation(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if bit.band(tl,LOCATION_SZONE)~=0 and re:IsActiveType(TYPE_TRAP) then
		Duel.NegateEffect(ev)
	end
end