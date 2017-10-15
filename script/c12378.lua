--Mecha Girl Laboratory
function c12378.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12378,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,12378)
	e2:SetCondition(c12378.spcon)
	e2:SetTarget(c12378.sptg)
	e2:SetOperation(c12378.spop)
	c:RegisterEffect(e2)
	--atkchange/draw/add
	local e3=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetTarget(c12378.target)
	e3:SetOperation(c12378.operation)
	c:RegisterEffect(e3)
	if c12378.counter==nil then
		c12378.counter=true
		c12378[0]=0
		c12378[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c12378.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_REMOVE)
		e3:SetOperation(c12378.addcount)
		Duel.RegisterEffect(e3,0)
	end
end
function c12378.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end
function c12378.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x3052) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12378.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c12378.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c12378.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c12378.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c12378.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_DECKSHF)
		tc:RegisterEffect(e1,true)
	end
end
function c12378.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c12378[0]=0
	c12378[1]=0
end
function c12378.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x3052) then
			local p=tc:GetReasonPlayer()
			c12378[p]=c12378[p]+1
		end
		tc=eg:GetNext()
	end
end
function c12378.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x3052)
end
function c12378.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3052) and c:IsAbleToHand()
end
function c12378.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=c12378[tp]>1 and Duel.IsExistingMatchingCard(c12378.filter1,tp,LOCATION_MZONE,0,1,nil)
	local b2=c12378[tp]>2 and Duel.IsPlayerCanDraw(tp,1)
	local b3=c12378[tp]>3 and Duel.IsExistingMatchingCard(c12378.filter2,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	if b1 then
		local g=Duel.GetMatchingGroup(c12378.filter1,tp,LOCATION_MZONE,0,nil)
	end
	if b2 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
	if b3 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c12378.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local act=false
	if c12378[tp]>1 and Duel.SelectYesNo(tp,aux.Stringid(12378,1))  then
	local g=Duel.GetMatchingGroup(c12378.filter1,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,3)
			e1:SetValue(1000)
			sc:RegisterEffect(e1)
			sc=g:GetNext()
			act=true
			end
		end
	end
	if c12378[tp]>2 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(12378,2)) then
		if act then Duel.BreakEffect() end
		Duel.Draw(tp,1,REASON_EFFECT)
		act=true
	end
	if c12378[tp]>3 and Duel.SelectYesNo(tp,aux.Stringid(12378,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c12378.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			if act then Duel.BreakEffect() end
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end