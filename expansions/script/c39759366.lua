--Master Deckuriboh
--Script by XGlitchy30
function c39759366.initial_effect(c)
	--Deck Master
	aux.AddOrigDeckmasterType(c)
	aux.EnableDeckmaster(c,nil,nil,c39759366.mscon,nil,nil,c39759366.penalty)
	--Ability: Kuriblock
	local ab=Effect.CreateEffect(c)
	ab:SetType(EFFECT_TYPE_FIELD)
	ab:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ab:SetCode(EFFECT_CHANGE_DAMAGE)
	ab:SetRange(LOCATION_SZONE)
	ab:SetTargetRange(1,0)
	ab:SetCondition(aux.CheckDMActivatedState)
	ab:SetValue(c39759366.damval)
	c:RegisterEffect(ab)
	--Monster Effects--
	--Activate DM
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,c:GetOriginalCode())
	e1:SetCondition(c39759366.tgcon)
	e1:SetTarget(c39759366.tgtg)
	e1:SetOperation(c39759366.tgop)
	c:RegisterEffect(e1)
end
--Deck Master Functions
function c39759366.DMCost(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,39759366,RESET_EVENT+EVENT_CUSTOM+39759366,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c39759366.regdamcon)
	e1:SetOperation(c39759366.regdam)
	Duel.RegisterEffect(e1,tp)
end
function c39759366.regdamcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c39759366.regdam(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,lp-300)
end
function c39759366.mscon(e,c)
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c39759366.penalty(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,500,REASON_EFFECT)
end
--Ability: Kuriblock
function c39759366.damval(e,re,val,r,rp,rc)
	if val<=500 then return 0 else return val end
end
--Monster Effects--
--Activate DM
function c39759366.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetReason(),0x8)==0x8 and e:GetHandler():GetFlagEffect(3338)==0
end
function c39759366.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_GRAVE) and Duel.CheckLocation(tp,LOCATION_SZONE,2)
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),TYPE_DECKMASTER)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c39759366.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_GRAVE) or not Duel.CheckLocation(tp,LOCATION_SZONE,2) or Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),TYPE_DECKMASTER) then
		return
	end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP_ATTACK,true)
	Duel.MoveSequence(c,2)
	--register Activation
	c:RegisterFlagEffect(3339,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE,1)
	c:SetFlagEffectLabel(3339,99)
	c:ResetFlagEffect(3340)
	if Duel.GetFlagEffect(tp,39759366)==0 then
		--Cost payment
		Debug.Message('a')
		local m=_G["c"..c:GetCode()]
		m.DMCost(e,tp,eg,ep,ev,re,r,rp)
	end
end