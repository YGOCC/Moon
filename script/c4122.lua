--水晶機巧－スモーガ－
function c4122.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c4122.target)
	e1:SetOperation(c4122.activate)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4122,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,4122)
	e2:SetCost(c4122.thcost)
	e2:SetTarget(c4122.thtg)
	e2:SetOperation(c4122.thop)
	c:RegisterEffect(e2)
end
function c4122.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x10041036) and c:GetFlagEffect(4123)==0 and c:GetFlagEffect(4122)==0
		and c:GetFlagEffect(4121)==0
end
function c4122.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c4122.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c4122.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c4122.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c4122.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		tc:RegisterFlagEffect(4122,RESET_EVENT+0x1fe0000,0,0) 
		local e1=Effect.CreateEffect(tc)
		e1:SetDescription(aux.Stringid(4122,1))
		e1:SetCategory(CATEGORY_POSITION)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetCondition(c4122.descon)
		e1:SetOperation(c4122.desop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(tc)
		e2:SetDescription(aux.Stringid(4122,2))
		e2:SetCategory(CATEGORY_RECOVER)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e2:SetCode(EVENT_BATTLE_DESTROYING)
		e2:SetCondition(c4122.recon)
		e2:SetTarget(c4122.rectg)
		e2:SetOperation(c4122.recop)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		if tc:IsRelateToEffect(e) and tc:IsType(TYPE_XYZ) and tc:IsFaceup() and c:IsRelateToEffect(e) then
			c:CancelToGrave()
			Duel.Overlay(tc,Group.FromCards(c))
		end
	end
end
function c4122.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsType(TYPE_MONSTER)
end
function c4122.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() and bc:IsCanTurnSet() then
		Duel.ChangePosition(bc,POS_FACEDOWN_DEFENSE)
	end
end
function c4122.recon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsControler(1-tp)
end
function c4122.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local rec=e:GetHandler():GetBattleTarget():GetAttack()/2
	if rec<0 then rec=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,rec)
end
function c4122.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c4122.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c4122.thfilter(c)
	return c:IsSetCard(0x1004) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c4122.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4122.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c4122.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c4122.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
