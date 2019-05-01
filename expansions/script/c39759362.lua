--Doppio Evocatore
--Script by XGlitchy30
function c39759362.initial_effect(c)
	--Deck Master
	aux.AddOrigDeckmasterType(c)
	aux.EnableDeckmaster(c,nil,nil,c39759362.mscon,nil,nil,c39759362.penalty)
	--Ability: Double Invocation
	local ab=Effect.CreateEffect(c)
	ab:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	ab:SetType(EFFECT_TYPE_FIELD)
	ab:SetRange(LOCATION_SZONE)
	ab:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	ab:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	ab:SetCondition(aux.CheckDMActivatedState)
	ab:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_NORMAL))
	c:RegisterEffect(ab)
	--Monster Effects--
	--search+summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),1))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,c:GetOriginalCode())
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c39759362.thtg)
	e1:SetOperation(c39759362.thop)
	c:RegisterEffect(e1)
	--Register Normal Summons
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	ge1:SetCode(EVENT_SUMMON_SUCCESS)
	ge1:SetRange(LOCATION_SZONE)
	ge1:SetCondition(c39759362.regcon)
	ge1:SetOperation(c39759362.regop)
	c:RegisterEffect(ge1)
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	ge2:SetCode(EVENT_SUMMON_SUCCESS)
	ge2:SetRange(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK+LOCATION_EXTRA+LOCATION_OVERLAY)
	ge2:SetOperation(c39759362.regop2)
	c:RegisterEffect(ge2)
	local sg=Group.CreateGroup()
	sg:KeepAlive()
	ge2:SetLabelObject(sg)
end
c39759362.count1 = 0
c39759362.count2 = 0
c39759362.class_count1 = 0
c39759362.class_count2 = 0
--filters
function c39759362.tgfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetOriginalLevel()>0
		and ((Duel.IsExistingMatchingCard(c39759362.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetOriginalLevel()) and Duel.IsExistingMatchingCard(c39759362.sumfilter,tp,LOCATION_HAND,0,1,nil))
		or Duel.IsExistingMatchingCard(aux.AND(c39759362.thfilter,c39759362.sumfilter),tp,LOCATION_DECK,0,1,nil,c:GetOriginalLevel()))
end
function c39759362.thfilter(c,lv)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:GetOriginalLevel()==lv
end
function c39759362.sumfilter(c)
	return c:IsSummonable(true,nil)
end
--Deck Master Functions
function c39759362.DMCost(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,39759362)==0 then
		Duel.RegisterFlagEffect(tp,39759362,RESET_EVENT+EVENT_CUSTOM+39759362,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE,1)
		if Duel.GetFlagEffect(1-tp,39759362)==0 then
			Duel.SetFlagEffectLabel(tp,39759362,99)
			c39759362.count1 = 0
		else
			Duel.SetFlagEffectLabel(tp,39759362,100)
			c39759362.count2 = 0
		end
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e0:SetRange(LOCATION_SZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK+LOCATION_EXTRA+LOCATION_OVERLAY)
		e0:SetTargetRange(1,0)
		e0:SetTarget(c39759362.limittg)
		Duel.RegisterEffect(e0,tp)
		local e0x=Effect.CreateEffect(e:GetHandler())
		e0x:SetType(EFFECT_TYPE_FIELD)
		e0x:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e0x:SetRange(LOCATION_SZONE)
		e0x:SetCode(EFFECT_LEFT_SPSUMMON_COUNT)
		e0x:SetTargetRange(1,0)
		e0x:SetValue(c39759362.countval)
		Duel.RegisterEffect(e0x,tp)
	end
end
function c39759362.mscon(e,c)
	if Duel.GetFlagEffectLabel(tp,39759362)==99 then
		return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and c39759362.class_count1 >= 4
	else
		return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and c39759362.class_count2 >= 4
	end
end
function c39759362.penalty(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,e:GetHandler():GetOriginalCode())
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_SELF_TURN+RESET_PHASE+PHASE_END,2)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
--SpSummon Limit Count
function c39759362.limittg(e,c,tp)
	local t1=Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
	if Duel.GetFlagEffectLabel(e:GetHandler():GetControler(),39759362)==99 then
		return t1>=c39759362.count1
	else
		return t1>=c39759362.count2
	end
end
function c39759362.countval(e,re,tp)
	local t1=Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
	if Duel.GetFlagEffectLabel(e:GetHandler():GetControler(),39759362)==99 then
		if t1>=c39759362.count1 then 
			return 0 
		else 
			return (c39759362.count1)-t1 
		end
	else
		if t1>=c39759362.count2 then 
			return 0 
		else 
			return (c39759362.count2)-t1 
		end
	end
end
--Register Normal Summons
function c39759362.regcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.CheckDMActivatedState(e) and Duel.GetFlagEffect(tp,39759362)~=0
end
function c39759362.regop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetSummonPlayer()==tp then
			if Duel.GetFlagEffectLabel(tp,39759362)==99 then
				c39759362.count1 = c39759362.count1+1
				e:GetHandler():SetTurnCounter(c39759362.count1)
			else
				c39759362.count2 = c39759362.count2+1
				e:GetHandler():SetTurnCounter(c39759362.count2)
			end
		end
		tc=eg:GetNext()
	end
end
function c39759362.regop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local g=e:GetLabelObject()
	while tc do
		if tc:GetSummonPlayer()==tp then
			if g:GetCount()<=0 then
				g:AddCard(tc)
			else
				local check=true
				for i in aux.Next(g) do
					if i:GetCode()==tc:GetCode() then
						check=false
					end
				end
				if check then
					g:AddCard(tc)
				end
			end
		end
		tc=eg:GetNext()
	end
	if Duel.GetFlagEffectLabel(tp,39759362)==99 then
		c39759362.class_count1=g:GetCount()
	else
		c39759362.class_count2=g:GetCount()
	end
end
--search+summon
function c39759362.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c39759362.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c39759362.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c39759362.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c39759362.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c39759362.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetOriginalLevel())
		if g:GetCount()>0 then
			if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
				Duel.ConfirmCards(1-tp,g)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
				local g2=Duel.SelectMatchingCard(tp,c39759362.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
				if g2:GetCount()>0 then
					Duel.Summon(tp,g2:GetFirst(),true,nil)
				end
			end
		end
	end
end