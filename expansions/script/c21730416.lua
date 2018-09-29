--A.O. Connector
function c21730416.initial_effect(c)
	--link procedure
	aux.AddLinkProcedure(c,nil,2,2,c21730416.lcheck)
	c:EnableReviveLimit()
	--activate or set from hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21730416,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_END_PHASE)
	e2:SetCondition(c21730416.accon)
	e2:SetTarget(c21730416.actg)
	e2:SetOperation(c21730416.acop)
	c:RegisterEffect(e2)
	--attributes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c21730416.regcon)
	e3:SetOperation(c21730416.regop)
	c:RegisterEffect(e3)
	--value
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c21730416.valcheck)
	c:RegisterEffect(e4)
end
--link procedure
function c21730416.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x719)
end
--activate or set from hand
function c21730416.acfilter(c,tp)
	return (c:IsCode(21730411) and c:GetActivateEffect():IsActivatable(tp,true,true))
		or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable())
end
function c21730416.accon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetMaterial():GetClassCount(Card.GetRace)==1
end
function c21730416.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c21730416.acfilter,tp,LOCATION_HAND,0,nil,tp)
	if chk==0 then return mg:GetCount()>0
		and (mg:IsExists(Card.IsCode,1,nil,21730411) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) end
end
function c21730416.acop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c21730416.acfilter,tp,LOCATION_HAND,0,nil,tp)
	if mg:GetCount()<=0
		or (not mg:IsExists(Card.IsCode,1,nil,21730411) and Duel.GetLocationCount(tp,LOCATION_SZONE)<=0) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c21730416.acfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	if tc then
		local te=tc:GetActivateEffect()
		local b1=tc:IsCode(21730411) and te:IsActivatable(tp,true,true)
		local b2=tc:IsSSetable()
		if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(21730416,4))) then
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,21730411,te,0,tp,tp,Duel.GetCurrentChain())
		else
			Duel.SSet(tp,tc)
		end
	end
end
--attributes
function c21730416.regcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c21730416.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--event
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21730416,5))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x86c0000+RESET_PHASE+PHASE_END)
	e1:SetOperation(c21730416.evop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21730416,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+21730411)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c21730416.drcon)
	e2:SetTarget(c21730416.drtg)
	e2:SetOperation(c21730416.drop)
	c:RegisterEffect(e2)
	--add from deck to hand
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(21730416,2))
	e3:SetCondition(c21730416.thcon)
	e3:SetTarget(c21730416.thtg)
	e3:SetOperation(c21730416.thop)
	c:RegisterEffect(e3)
	--special summon token
	local e5=e2:Clone()
	e5:SetDescription(aux.Stringid(21730416,3))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e5:SetCondition(c21730416.tkcon)
	e5:SetTarget(c21730416.tktg)
	e5:SetOperation(c21730416.tkop)
	c:RegisterEffect(e5)
end
--event
function c21730416.evop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+21730411,e,r,rp,ep,ev)
end
--draw
function c21730416.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(21730416)~=0
end
function c21730416.drfilter(c)
	return c:IsSetCard(0x719)
end
function c21730416.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21730416.drfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2 and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c21730416.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c21730416.drfilter,tp,LOCATION_DECK,0,1,1,nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
--add from deck to hand
function c21730416.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(21730417)~=0
end
function c21730416.thfilter(c)
	return c:IsSetCard(0x719) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c21730416.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21730416.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21730416.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21730416.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--special summon token
function c21730416.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(21730418)~=0
end
function c21730416.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,21730414,0x719,0x4011,300,200,1,RACE_BEAST,ATTRIBUTE_LIGHT,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c21730416.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,21730414,0x719,0x4011,300,200,1,RACE_BEAST,ATTRIBUTE_LIGHT,POS_FACEUP) then return end
	local token=Duel.CreateToken(tp,21730414)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
--value
function c21730416.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_EARTH+ATTRIBUTE_WIND) then
		c:RegisterFlagEffect(21730416,RESET_EVENT+0x86c0000,0,1)
	end
	if g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WATER+ATTRIBUTE_FIRE) then
		c:RegisterFlagEffect(21730417,RESET_EVENT+0x86c0000,0,1)
	end
	if g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) then
		c:RegisterFlagEffect(21730418,RESET_EVENT+0x86c0000,0,1)
	end
end