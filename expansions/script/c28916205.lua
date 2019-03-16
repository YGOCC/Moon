--This file was automatically coded by Kinny's Numeron Code~!
local ref=_G['c'..28916205]
local id=28916205
function ref.initial_effect(c)
	--Effect 0
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND)
	e0:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetCountLimit(1)
	e0:SetTarget(ref.target0)
	e0:SetOperation(ref.operation0)
	c:RegisterEffect(e0)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1,28916205)
	e1:SetCondition(ref.condition1)
	e1:SetTarget(ref.target1)
	e1:SetOperation(ref.operation1)
	c:RegisterEffect(e1)
end
function ref.Search(c)
	return c:IsSetCard(1858) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function ref.SelfSS(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp)
end
function ref.SSetable(c)
	return c:IsSetCard(1858) and c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function ref.FaceUpMon(c)
	return c:IsPosition(POS_FACEUP) and c:IsType(TYPE_MONSTER)
end
--Effect 0
function ref.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.Search,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function ref.operation0(e,tp,eg,ep,ev,re,r,rp)
	local g0=Duel.SelectMatchingCard(tp,ref.Search,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(g0,tp,REASON_EFFECT)
	Duel.ConfirmCards(tp,g0)
end
--Effect 1
function ref.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(ref.FaceUpMon,tp,LOCATION_ONFIELD,0,1,nil)
end
function ref.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return ref.SelfSS(c,e,tp) and Duel.IsExistingTarget(ref.SSetable,tp,LOCATION_GRAVE,0,1,nil) end
	if chkc then return ref.SSetable(chkc) and c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
	local g1 = Duel.SelectTarget(tp,ref.SSetable,tp,LOCATION_GRAVE,0,1,1,nil)
end
function ref.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local g1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SSet(tp,g1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e1:SetValue(LOCATION_DECKBOT)
	g1:GetFirst():RegisterEffect(e1)
end
