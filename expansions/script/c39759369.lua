--Spadaccino Maestro Comandante
--Script by XGlitchy30
function c39759369.initial_effect(c)
	--Deck Master
	aux.AddOrigDeckmasterType(c)
	aux.EnableDeckmaster(c,nil,nil,-1,nil,nil,c39759369.penalty)
	--Ability: Battle Charisma
	local ab=Effect.CreateEffect(c)
	ab:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	ab:SetCategory(CATEGORY_ATKCHANGE)
	ab:SetType(EFFECT_TYPE_IGNITION)
	ab:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ab:SetRange(LOCATION_SZONE)
	ab:SetCondition(c39759369.condition)
	ab:SetTarget(c39759369.target)
	ab:SetOperation(c39759369.operation)
	c:RegisterEffect(ab)
	local ab2=Effect.CreateEffect(c)
	ab2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ab2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	ab2:SetRange(LOCATION_SZONE)
	ab2:SetCountLimit(1)
	ab2:SetCondition(c39759369.atkcon)
	ab2:SetOperation(c39759369.atkop)
	c:RegisterEffect(ab2)
	--Master Summon Custom Proc
	local ms=Effect.CreateEffect(c)
	ms:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ms:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
	ms:SetCode(EVENT_PHASE+PHASE_BATTLE)
	ms:SetRange(LOCATION_SZONE)
	ms:SetCountLimit(1)
	ms:SetCondition(c39759369.mscon)
	ms:SetOperation(c39759369.msop)
	c:RegisterEffect(ms)
	--Reset Stats
	local reg=Effect.CreateEffect(c)
	reg:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	reg:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	reg:SetCode(EVENT_LEAVE_FIELD)
	reg:SetOperation(c39759369.reset)
	c:RegisterEffect(reg)
	--Register Destruction
	if not c39759369.global_check then
		c39759369.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c39759369.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
--Reset Stats
function c39759369.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetCardData(CARDDATA_ATTACK,1800)
end
--Register Destruction
function c39759369.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsPreviousLocation(LOCATION_MZONE) and tc:IsReason(REASON_BATTLE) and tc:GetPreviousControler()~=tc:GetReasonPlayer() then
			if tc:GetReasonPlayer()==0 then 
				p1=true 
			else 
				p2=true 
			end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,30759369,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,30759369,RESET_PHASE+PHASE_END,0,1) end
end
--filters
function c39759369.cfilter(c)
	return c:IsFaceup() and c:IsAttackPos() and c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_MONSTER)
end
function c39759369.filter(c)
	return c:IsFaceup() and c:IsAttackPos() and c:GetFlagEffect(39759369)==0
end
--Deck Master Functions
function c39759369.DMCost(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c39759369.atlimit)
	Duel.RegisterEffect(e1,tp)
end
function c39759369.atlimit(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c39759369.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function c39759369.mscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetTurnPlayer()==tp and Duel.GetFlagEffect(tp,30759369)~=0
end
function c39759369.msop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_MASTER,tp,false,false) then return end
	if c then
		if Duel.SelectYesNo(tp,aux.Stringid(39759368,2)) then
			Duel.SpecialSummon(c,SUMMON_TYPE_MASTER,tp,tp,false,false,POS_FACEUP)
			c:RegisterFlagEffect(3340,RESET_EVENT+EVENT_CUSTOM+3340,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE,1)
		end
	end
end
function c39759369.penalty(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
--Ability: Battle Charisma
function c39759369.condition(e,tp,eg,ep,ev,re,r,rp)
	return aux.CheckDMActivatedState(e) and Duel.GetTurnPlayer()==tp
end
function c39759369.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c39759369.filter(chkc) end
	if chk==0 then return e:GetHandler():GetBaseAttack()>=100
		and Duel.IsExistingTarget(c39759369.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c39759369.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	tc:GetFirst():RegisterFlagEffect(39759369,RESET_PHASE+PHASE_END,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE,1)
end
function c39759369.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:GetBaseAttack()<100
		or tc:IsFacedown() or not tc:IsRelateToEffect(e) then 
			return 
	end
	local ct=math.floor(c:GetBaseAttack()/100)
	local t={}
	for i=1,ct do
		t[i]=i*100
	end
	local num=Duel.AnnounceNumber(tp,table.unpack(t))
	local valmin=c:GetBaseAttack()-num
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(valmin)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(num)
	tc:RegisterEffect(e2)
	c:SetCardData(CARDDATA_ATTACK,valmin)
	Duel.RegisterFlagEffect(tp,39759369,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
end
function c39759369.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.CheckDMActivatedState(e) and Duel.GetFlagEffect(tp,39759369)~=0 and Duel.GetTurnPlayer()==tp
end
function c39759369.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(c:GetBaseAttack()+500)
	c:RegisterEffect(e1)
	c:SetCardData(CARDDATA_ATTACK,c:GetBaseAttack()+500)
end