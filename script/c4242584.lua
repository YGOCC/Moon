--Lunar Phase: Explorer Pony Moon Burst
function c4242584.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--==Pendulum Effect==--
	-- Once per turn, if a "Lunar Phase" monster you control attacks your opponent directly: 
	-- Draw 1 card.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c4242584.cond)
	e1:SetOperation(c4242584.op)
	c:RegisterEffect(e1)
	--==Monster Effects==--
	--Trade
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4242584,1))
	e2:SetCountLimit(1,42425841)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
--	e2:SetCondition(c4242584.spcon)
	--e2:SetCost(c4242584.spcost)
	e2:SetTarget(c4242584.sptg)
	e2:SetOperation(c4242584.spop)
	c:RegisterEffect(e2)
	--To Hand 2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4242584,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(c4242584.thcost)
	e3:SetTarget(c4242584.thtg2)
	e3:SetOperation(c4242584.thop2)
	c:RegisterEffect(e3)
end

function c4242584.cond(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	return Duel.GetAttackTarget()==nil
	and tc:IsFaceup()
	and tc:IsSetCard(0x666)
	and ep~=tp
end

function c4242584.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
--Trade Pends
function c4242584.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c4242584.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck() and c:IsSetCard(0x666)
		and Duel.IsExistingMatchingCard(c4242584.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,c,e,tp)
end
function c4242584.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4242584.spcost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c4242584.cfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c4242584.cfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c4242584.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c4242584.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c4242584.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c4242584.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
    end
end


--To Hand 2
function c4242584.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c4242584.sfilter(c)
	return c:IsCode(4242564) and c:IsAbleToHand()
end
function c4242584.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c4242584.sfilter,tp,0x51,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x51)
end
function c4242584.thop2(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c4242584.sfilter,tp,0x51,0,1,1,nil):GetFirst()
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
