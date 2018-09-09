--S.G. Tinkerer
function c21730403.initial_effect(c)
--special summon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21730403,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c21730403.spcon)
	c:RegisterEffect(e1)
	--add from deck to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21730403,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_END_PHASE)
	e2:SetCost(c21730403.thcost)
	e2:SetTarget(c21730403.thtg)
	e2:SetOperation(c21730403.thop)
	c:RegisterEffect(e2)
end
--special summon from hand
function c21730403.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
--add from deck to hand
function c21730403.thfilter1(c)
	return c:IsSetCard(0x719)
end
function c21730403.thfilter2(c)
	return c:IsSetCard(0x719) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c21730403.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.CheckReleaseGroup(tp,c21730403.thfilter1,1,false,nil,nil,tp) end
	if Duel.Remove(c,POS_FACEUP,REASON_COST)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TURN_END)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCountLimit(1)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetOperation(c21730403.tgop)
		c:RegisterEffect(e1)
	end
	local g=Duel.SelectReleaseGroup(tp,c21730403.thfilter1,1,1,false,nil,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c21730403.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21730403.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21730403.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21730403.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--return to grave
function c21730403.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_RETURN)
end