--This file was automatically coded by Kinny's Numeron Code~!
local ref=_G['c'..28916207]
local id=28916207
function ref.initial_effect(c)
	aux.EnableCoronaNeo(c,1,1,ref.matfilter)
	--Effect 0
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOGRAVE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(ref.target0)
	e0:SetOperation(ref.operation0)
	c:RegisterEffect(e0)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1)
	e1:SetCondition(ref.condition1)
	e1:SetTarget(ref.target1)
	e1:SetOperation(ref.operation1)
	c:RegisterEffect(e1)
end
function ref.matfilter(c)
	return c:IsSetCard(1858)
end

function ref.STToGY(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function ref.ArchToGY(c)
	return c:IsSetCard(1858) and c:IsAbleToGrave()
end
function ref.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.STToGY,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function ref.operation0(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return false end
	local g0 = Duel.SelectMatchingCard(tp,ref.STToGY,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g0,REASON_EFFECT,tp)
end

function ref.triggerfilter(c,p)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==p
end
function ref.condition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(ref.triggerfilter,1,nil,tp)
end
function ref.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.ArchToGY,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function ref.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return false end
	local g0 = Duel.SelectMatchingCard(tp,ref.ArchToGY,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g0,REASON_EFFECT,tp)
end
