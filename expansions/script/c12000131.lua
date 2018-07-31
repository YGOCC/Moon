--Teutonic Knight - Honored Ventalvary
function c12000131.initial_effect(c)
	aux.AddLinkProcedure(c,c12000131.matfilter,1,1)
	c:EnableReviveLimit()
--Return 1 Spell/Trap to the Deck
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12000131,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(c12000131.condition)
	e1:SetTarget(c12000131.target)
	e1:SetOperation(c12000131.operation)
	c:RegisterEffect(e1)
--Special Summon From Hand
local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(12000131,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1)
	e2:SetCondition(c12000131.incon)
    e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c12000131.spcost)
	e2:SetTarget(c12000131.sptg)
	e2:SetOperation(c12000131.spop)
    c:RegisterEffect(e2)
end
--Link Summon
function c12000131.matfilter(c)
	return c:IsLinkSetCard(0x857) and not c:IsAttribute(ATTRIBUTE_WIND)
end
--Return 1 Spell/Trap to the Deck
function c12000131.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and Duel.GetTurnPlayer()~=e:GetHandler():GetControler()
end
function c12000131.filter(c)
	return c:IsAbleToDeck() and c:GetSequence()<5
end
function c12000131.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c12000131.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12000131.filter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c12000131.filter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,1-tp,LOCATION_SZONE)
end
--Special Summon From Hand
function c12000131.incon(e)
	return e:GetHandler():GetLinkedGroupCount()==0
end
function c12000131.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c12000131.spfilter1(c,e,tp)
	return c:IsSetCard(0x857) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12000131.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c12000131.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c12000131.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c12000131.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end