--Spellbook Mage Knight
function c249001031.initial_effect(c)
	--special summon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c249001031.spcon)
	c:RegisterEffect(e1)
	--special summon from GY or banished zone
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCondition(c249001031.spcon2)
	e2:SetOperation(c249001031.spop2)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75878039,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(c249001031.target)
	e3:SetOperation(c249001031.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCondition(c249001031.discon)
	e6:SetOperation(c249001031.disop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_DISABLE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(0,LOCATION_MZONE)
	e8:SetTarget(c249001031.distg)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e9)
	--atk down
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(31833038,0))
	e10:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DESTROY)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_MZONE)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e10:SetCountLimit(1)
	e10:SetTarget(c249001031.atktg)
	e10:SetOperation(c249001031.atkop)
	c:RegisterEffect(e10)
end
function c249001031.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.IsExistingMatchingCard(Card.IsSetCard,c:GetControler(),LOCATION_GRAVE,0,2,nil,0x106E)
end
function c249001031.spcostfilter1(c)
	return c:IsDiscardable() and c:IsSetCard(0x106E) and c:IsType(TYPE_SPELL)
end
function c249001031.spcostfilter2(c)
	return c:IsDiscardable() and c:IsRace(RACE_SPELLCASTER)
end
function c249001031.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) or Duel.GetMZoneCount(tp)<=0 then return false end
	return Duel.IsExistingMatchingCard(c249001031.spcostfilter1,c:GetControler(),LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c249001031.spcostfilter2,c:GetControler(),LOCATION_HAND,0,1,nil)
end
function c249001031.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.GetMatchingGroup(c249001031.spcostfilter1,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c249001031.spcostfilter2,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	sg:Merge(g2:Select(tp,1,1,nil))
	Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
end
function c249001031.filter(c)
	return c:IsSetCard(0x106E) and c:IsAbleToHand() and c:IsType(TYPE_SPELL)
end
function c249001031.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249001031.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c249001031.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c249001031.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c249001031.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	if not c then return false end
	if c:IsControler(1-tp) then c=Duel.GetAttacker() end
	return c and c==e:GetHandler()
end
function c249001031.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if tc:IsControler(tp) then tc=Duel.GetAttacker() end
	tc:RegisterFlagEffect(249001031,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
end
function c249001031.distg(e,c)
	return c:GetFlagEffect(249001031)~=0
end
function c249001031.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsFaceup() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c249001031.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not tc:IsFaceup() or not tc:IsRelateToEffect(e) then return end
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-800)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		if tc:GetAttack() == 0 or (tc:GetDefense()==0 and not tc:IsType(TYPE_LINK)) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	elseif tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	local ct=3
	while Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,tc) and ct>0 and Duel.SelectYesNo(tp,502) do
		Duel.ClearTargetCard()
		Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,tc)
		tc=Duel.GetFirstTarget()
		if tc:IsType(TYPE_MONSTER) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(-800)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			if tc:GetAttack() == 0 or (tc:GetDefense()==0 and not tc:IsType(TYPE_LINK)) then
				Duel.Destroy(tc,REASON_EFFECT)
			end
		elseif tc:IsFaceup() and tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
		ct=ct-1
	end
end