--Teutonic Knight - Aquaidiance
function c12000123.initial_effect(c)
--Special Summon from hand
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12000123,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,12000123)
	e1:SetCondition(c12000123.spcon)
	e1:SetCost(c12000123.spcost)
	e1:SetTarget(c12000123.sptg)
	e1:SetOperation(c12000123.spop)
	c:RegisterEffect(e1)
--Search 
local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000123,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,12000223)
	e2:SetCondition(c12000123.rmcon)
	e2:SetTarget(c12000123.thtg)
	e2:SetOperation(c12000123.thop)
	c:RegisterEffect(e2)
 --Return to Deck and Draw 1
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(12000123,2))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCost(c12000123.drcost)
    e3:SetTarget(c12000123.drtg)
    e3:SetOperation(c12000123.drop)
    c:RegisterEffect(e3)
end
--Special Summon from hand
function c12000123.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c12000123.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c12000123.spfilter1(c,e,tp)
	return c:IsSetCard(0x857) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12000123.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c12000123.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c12000123.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c12000123.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
--Search
function c12000123.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x857) or re:GetHandler():IsSetCard(0x858) and not re:GetHandler():IsCode(12000123)
end
function c12000123.thfilter(c)
	return c:IsSetCard(0x857) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c12000123.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000123.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12000123.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12000123.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--Return to Deck and Draw 1
function c12000123.tdfilter(c)
     return c:IsSetCard(0x857) and c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost()
end
function c12000123.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c12000123.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c12000123.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c12000123.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c12000123.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end