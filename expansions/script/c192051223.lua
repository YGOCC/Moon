--Steelus Haven
function c192051223.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c192051223.target)
	e1:SetOperation(c192051223.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(192051223,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(function() return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 end)
	e2:SetCost(c192051223.spcost)
	e2:SetTarget(c192051223.sptg)
	e2:SetOperation(c192051223.spop)
	c:RegisterEffect(e2)
	--negation
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(0xff)
	e3:SetCondition(c192051223.tgcon)
	e3:SetOperation(c192051223.tgop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(192051223,ACTIVITY_CHAIN,c192051223.act)
end
function c192051223.act(re,tp,cid)
	local rc=re:GetHandler()
	return not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not rc:IsSetCard(0x617))
end
function c192051223.filter(c)
	return c:IsSetCard(0x617) and c:GetLevel()==3 and c:IsAbleToHand()
end
function c192051223.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c192051223.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c192051223.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c192051223.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c192051223.cfilter(c,e,tp)
	local code=c:GetCode()
	return c:IsSetCard(0x617) and Duel.IsExistingMatchingCard(c192051223.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,code)
end
function c192051223.spfilter(c,e,tp,code)
	return c:IsSetCard(0x617) and c:GetCode()~=code and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c192051223.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c192051223.cfilter,1,nil,e,tp) end
	local g=Duel.SelectReleaseGroup(tp,c192051223.cfilter,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.Release(g,REASON_COST)
end
function c192051223.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c192051223.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c192051223.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,code)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c192051223.tgcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetCurrentPhase()==PHASE_END and tp==Duel.GetTurnPlayer()
end
function c192051223.tgop(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	if Duel.GetCustomActivityCount(192051223,tp,ACTIVITY_CHAIN)>0 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCountLimit(1)
		e3:SetCode(EVENT_ADJUST)
		e3:SetRange(0xff)
		e3:SetCondition(c192051223.negcon)
		e3:SetOperation(c192051223.negop)
		e3:SetReset(RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e3)
	end
end
function c192051223.negcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetCurrentPhase()==PHASE_DRAW and tp~=Duel.GetTurnPlayer()
end
function c192051223.negop(e)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end
