--Xyz-Magician Transhifter
function c249000053.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetOperation(c249000053.regop)
	c:RegisterEffect(e1)
	--change type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c249000053.tg)
	e2:SetOperation(c249000053.op)
	c:RegisterEffect(e2)
end
function c249000053.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(249000053,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1,249000053)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTarget(c249000053.thtg)
	e1:SetOperation(c249000053.thop)
	e1:SetCountLimit(1,249000053)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c249000053.filter1(c)
	return c:IsSetCard(0x2073) and c:IsAbleToHand() and not c:IsCode(249000053)
end
function c249000053.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000053.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c249000053.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c249000053.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c249000053.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c249000053.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000053.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c249000053.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c249000053.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT) then
			local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
			local lc=g1:GetFirst()
			local race=g:GetFirst():GetRace()
			local att=g:GetFirst():GetAttribute()
			while lc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
				e1:SetRange(LOCATION_MZONE)
				e1:SetValue(att)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				lc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e2:SetCode(EFFECT_CHANGE_RACE)
				e2:SetRange(LOCATION_MZONE)
				e2:SetValue(race)
				e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				lc:RegisterEffect(e2)
				lc=g1:GetNext()
			end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetTargetRange(1,0)
			e1:SetTarget(c249000053.splimit)
			Duel.RegisterEffect(e1,tp)	
		end
	end
end
function c249000053.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and (not c:IsType(TYPE_XYZ))
end

